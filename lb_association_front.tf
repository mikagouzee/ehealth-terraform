resource "azurerm_network_interface_backend_address_pool_association" "front_vm" {
  for_each = module.front_nic.nic_id

  network_interface_id    = each.value
  ip_configuration_name   = "internal"
  backend_address_pool_id = module.front_load_balancer.backend_pool_id
}
