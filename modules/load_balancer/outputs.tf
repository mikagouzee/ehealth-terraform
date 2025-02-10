output "lb_id" {
  description = "ID Load Balancer"
  value       = azurerm_lb.this.id
}

output "backend_pool_id" {
  description = "ID Backend Pool"
  value       = azurerm_lb_backend_address_pool.this.id
}
