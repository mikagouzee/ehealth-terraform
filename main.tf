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
  subnet_names         = ["public_subnet", "private_subnet"]
  subnet_prefixes      = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "network_security_group" {
  source = "./modules/nsg"

  nsg_name = var.nsg_name
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
      source_address_prefix      = "*"
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
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}