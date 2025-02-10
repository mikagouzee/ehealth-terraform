
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

//define a local variable that will iterate on the array of subnets and associate their names to their id
locals {
  subnet_id_map = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}