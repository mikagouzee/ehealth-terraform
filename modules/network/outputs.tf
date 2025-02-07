output "subnet_ids" {
  value = local.subnet_id_map
}

output "nic_ids" {
  value = azurerm_network_interface.nic[*].id
}
