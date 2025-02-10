output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnets" {
  value = azurerm_subnet.subnet[*].id
}

//this will allow the main conf to retrieve the ids of each subnet
//this way we can pass them to the NIC for instance
output "subnet_ids" {
  value = local.subnet_id_map
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}