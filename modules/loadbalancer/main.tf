resource "azurerm_lb" "lb" {
  name = var.lb_name
  location = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name = var.frontendIpConfig.name
    public_ip_address_id = lookup(var.frontendIpConfig, "public_ip_address_id", null)
    private_ip_address = lookup(var.frontendIpConfig, "private_ip_address", null)
    private_ip_address_allocation = lookup(var.frontendIpConfig, "private_ip_address_allocation", null)
  }
}


resource "azurerm_lb_backend_address_pool" "lb_addresspool" {
  name                = "web-backend"
  loadbalancer_id     = azurerm_lb.lb.id
}

