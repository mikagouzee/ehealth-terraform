
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


###FRONT END###

module "public_ip_front" {
  source = "./modules/public_ip"

  # count = var.front_instances
  public_ip_name = "public_ip_front"
  resource_group_location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"
}

module "frontLoadbalancer" {
  source = "./modules/loadbalancer"
  lb_name = "lb-public"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontendIpConfig = {
    name = "lb_public_fip_name"
    public_ip_address_id = module.public_ip_front.public_ip_id
  }
}

module "lb_front_association" {
  source = "./modules/loadbalancer/lb_addresspool_association"
  nic_ids                 = [for i in range(var.front_instances) : module.front_nic[i].nic_id]
  ip_configuration_name   = "internal"
  backend_address_pool_id = module.frontLoadbalancer.addressPoolId
}

module "lbrule_front_http" {
  source = "./modules/loadbalancer/lbrules"

  ruleName              = "http_rule"
  lb_id                 = module.frontLoadbalancer.id
  protocol              = "Tcp"
  inport                = 80
  outport               = 80
  //we should ideally implement a var to fetch the exact FIP config
  fipconfigName         = module.frontLoadbalancer.frontend_ip_configuration_name
  poolId                = [module.frontLoadbalancer.addressPoolId] 
}

module "lbrule_front_ssh" {
  source = "./modules/loadbalancer/lbrules"

  ruleName              = "ssh_rule"
  lb_id                 = module.frontLoadbalancer.id
  protocol              = "Tcp"
  inport                = 22
  outport               = 22
  //we should ideally implement a var to fetch the exact FIP config
  fipconfigName         = module.frontLoadbalancer.frontend_ip_configuration_name
  poolId                = [module.frontLoadbalancer.addressPoolId] 
}

module "public_nsg" {
  source = "./modules/nsg"

  nsg_name = "publicNSG"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  
  security_rules = [
    {
      name                       = "SSH"
      priority                   = 1001
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = module.public_ip_front.address
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 1002
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = module.public_ip_front.address
      destination_address_prefix = "*"
    }
  ]
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
      # public_ip_address_id = module.public_ip_front[count.index].public_ip_id 
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
module "backLoadbalancer" {
  source = "./modules/loadbalancer"
  lb_name = "lb-private"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontendIpConfig = {
    name = "lb_private_fip_name"
    subnet_id = module.subnet.subnet_ids["private_subnet"]
    private_ip_address_allocation = "Dynamic"
  }
}

module "lb_back_association" {
  source = "./modules/loadbalancer/lb_addresspool_association"
  nic_ids                 = [for i in range(var.front_instances) : module.front_nic[i].nic_id]
  ip_configuration_name   = "internal"
  backend_address_pool_id = module.backLoadbalancer.addressPoolId
}

module "lbrule_back_http" {
  source = "./modules/loadbalancer/lbrules"

  ruleName              = "http_rule"
  lb_id                 = module.backLoadbalancer.id
  protocol              = "Tcp"
  inport                = 80
  outport               = 80
  //we should ideally implement a var to fetch the exact FIP config
  fipconfigName         = module.backLoadbalancer.frontend_ip_configuration_name
  poolId                = [module.backLoadbalancer.addressPoolId] 
}

module "lbrule_back_ssh" {
  source = "./modules/loadbalancer/lbrules"

  ruleName              = "ssh_rule"
  lb_id                 = module.backLoadbalancer.id
  protocol              = "Tcp"
  inport                = 22
  outport               = 22
  //we should ideally implement a var to fetch the exact FIP config
  fipconfigName         = module.backLoadbalancer.frontend_ip_configuration_name
  poolId                = [module.backLoadbalancer.addressPoolId] 
}

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

