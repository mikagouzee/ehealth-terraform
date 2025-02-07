resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location =  var.resource_group_location

    tags = {
        environment = "production"
    }
}

module "vnet" {
  source = "./modules/vnet"
  vnet_name            = "myVNet"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  address_space        = ["10.0.0.0/16"]
  subnet_names         = ["public_subnet", "private_subnet", "db"]
  subnet_prefixes      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "network_security_group" {
  source = "./modules/nsg"

  nsg_name = var.nsg_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}

module "front_nic" {
  source = "./modules/nic"
  nic_name = "front-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids = module.vnet.subnet_ids
  ip_configuration = {
      name = "internal"
      subnet_name = "public"
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = ""
    }
}

module "backend_nic" {
  source              = "./modules/nic"
  nic_name            = "backend-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids          = module.vnet.subnet_ids
  ip_configuration = {
      name                      = "internal"
      subnet_name               = "private"
      private_ip_address_allocation = "Dynamic"
    }
  
}

module "db_nic" {
  source              = "./modules/nic"
  nic_name            = "db-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_ids          = module.vnet.subnet_ids
  ip_configuration = {
      name                      = "internal"
      subnet_name               = "db"
      private_ip_address_allocation = "Dynamic"
    }
  
}