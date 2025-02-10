resource "azurerm_lb_rule" "lb_rule" {
  name                            = var.ruleName //"http_rule"
  loadbalancer_id                 = var.lb_id //azurerm_lb.lb.id
  protocol                        = var.protocol // "Tcp"
  frontend_port                   = var.inport //80
  backend_port                    = var.outport //80
  //we should ideally implement a var to fetch the exact FIP config
  frontend_ip_configuration_name  = var.fipconfigName  //azurerm_lb.lb.frontend_ip_configuration[0].name
  backend_address_pool_ids        = var.poolId //[azurerm_lb_backend_address_pool.lb_addresspool.id]
}