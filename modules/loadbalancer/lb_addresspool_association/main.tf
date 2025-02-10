resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  for_each = {
    for idx, nic_id in var.nic_ids : idx => nic_id
  }
  network_interface_id = each.value
  ip_configuration_name = var.ip_configuration_name
  backend_address_pool_id = var.backend_address_pool_id
}
