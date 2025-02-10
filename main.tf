
###RESSOURCE GROUP###
resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location =  var.resource_group_location

    tags = {
        environment = "production"
    }
}

### NETWORK ###
module "vnet" {
  source = "./modules/vnet"
  vnet_name            = "myVNet"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  address_space        = ["10.0.0.0/16"]

  # subnet_names         = ["public_subnet", "private_subnet", "db_subnet"]
  # subnet_prefixes      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "subnet" {
  source = "./modules/sub"
  vnet_name = module.vnet.vnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  resource_group_location = azurerm_resource_group.rg.location
  subnet_names         = var.subnet_names
  subnet_prefixes      = var.subnet_prefixes
}


module "db_nsg"{
source              = "./modules/nsg"
  nsg_name            = "dbNSG"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_rules = [
    {
      name                       = "AllowMySQLFromBackend"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3306"
      source_address_prefix      = "10.0.2.0/24"
      destination_address_prefix = "*"
    }
  ]
}

###FRONT END###
module "public_nsg" {
  source = "./modules/nsg"

  nsg_name = "publicNSG"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  //keep default rules for public network
}

module "public_ip_front" {
  source = "./modules/public_ip"

  count = var.front_instances
  public_ip_name = "public_ip_front_${count.index}"
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
}

module "front_nic" {
  source = "./modules/nic"

  count = var.front_instances
  nic_name = "front-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids = module.subnet.subnet_ids
  ip_configuration = {
      name = "internal"
      subnet_name = "public_subnet"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = module.public_ip_front[count.index].public_ip_id 
    }
}

module "front" {
  source = "./modules/linux-vm"
  
  count = var.front_instances

  vm_name = var.front_vm_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size = var.front_vm_size

  nic_id = [module.front_nic[count.index].nic_id]

  admin_username = var.front_vm_username
  password_auth = true

  subnet_id = module.subnet.subnet_ids["public_subnet"]

  source_image_reference = {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  //storage account types : "Premium_LRS" "Standard_LRS" "StandardSSD_LRS" "StandardSSD_ZRS" "Premium_ZRS"
  os_disk = {
    name = ""
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}

resource "azurerm_network_interface_security_group_association" "front_assoc" {
  for_each = {for idx, nic in module.front_nic: idx => nic}
  network_interface_id = each.value.nic_id
  network_security_group_id = module.public_nsg.nsg_id
}


###BACK END###

module "private_nsg"{
  source = "./modules/nsg"
  nsg_name = "privateNSG"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location

  security_rules = [
    {
      name                       = "AllowHTTPFromFront"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.0.1.0/24"
      destination_address_prefix = "*"
    }
  ]
}

module "backend_nic" {
  source              = "./modules/nic"

  count = var.back_instances

  nic_name            = "backend-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids          = module.subnet.subnet_ids
  ip_configuration = {
      name                      = "internal"
      subnet_name               = "private_subnet"
      private_ip_address_allocation = "Dynamic"
    }
  
}

module "back" {
  source = "./modules/linux-vm"

  count               = var.back_instances
  vm_name             = var.back_vm_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  nic_id              = [module.backend_nic[count.index].nic_id]
  vm_size             = var.back_vm_size

  admin_username      = var.back_vm_username
  password_auth       = true

  subnet_id           = module.subnet.subnet_ids["public_subnet"]

  source_image_reference = {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  os_disk = {
    name = ""
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}

resource "azurerm_network_interface_security_group_association" "back_assoc" {
  for_each = {for idx, nic in module.backend_nic: idx => nic}

  network_interface_id = each.value.nic_id
  network_security_group_id = module.private_nsg.nsg_id
}

###DATABASE###
module "db_nic" {
  source              = "./modules/nic"
  nic_name            = "db-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids          = module.subnet.subnet_ids
  ip_configuration = {
      name                      = "internal"
      subnet_name               = "db_subnet"
      private_ip_address_allocation = "Dynamic"
    }
  
}

module "storage" {
  source               = "./modules/storage_account"
  storage_account_name = "ehealthstorage${random_string.suffix.result}"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  container_names      = ["patient-files", "doctor-files"]
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_network_interface_security_group_association" "db_assoc" {
  network_interface_id = module.subnet.subnet_ids["db_subnet"]
  network_security_group_id = module.db_nsg.nsg_id
}

