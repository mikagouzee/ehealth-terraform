module "backend_load_balancer" {
  source              = "./modules/load_balancer"
  lb_name             = "BackendLoadBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  is_public           = false
  subnet_id           = module.vnet.subnet_ids["private_subnet"]
}
