output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnets" {
  value = azurerm_subnet.subnet[*].id
}
