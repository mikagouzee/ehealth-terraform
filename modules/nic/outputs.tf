output "nic_id" {
  value = azurerm_network_interface.nic.id
}

output "nic_ids" {
  value = azurerm_network_interface.nic[*].id
}