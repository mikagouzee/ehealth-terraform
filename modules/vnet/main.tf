resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

//define a local variable that will iterate on the array of subnets and associate their names to their id
locals {
  subnet_id_map = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}

//this will allow the main conf to retrieve the ids of each subnet
//this way we can pass them to the NIC for instance
output "subnet_ids" {
  value = local.subnet_id_map
}