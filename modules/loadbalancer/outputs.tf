output "id" {
  value = azurerm_lb.lb.id
}

output "frontend_ip_configuration_name" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].name
}

output "addressPoolId" {
  value = azurerm_lb_backend_address_pool.lb_addresspool.id
}

# output "lb_public_ip" {
#   value = azurerm_public_ip.public_ip.ip_address
# }
