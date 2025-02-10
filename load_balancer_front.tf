module "front_load_balancer" {
  source              = "./modules/load_balancer"
  lb_name             = "FrontLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  is_public           = true
  public_ip_id        = module.public_ip_front.public_ip_id
}
