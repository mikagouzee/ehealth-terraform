resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

locals {
  subnet_id_map = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}

resource "azurerm_network_interface" "nic" {
  count                = length(var.nic_configs)
  name                 = var.nic_configs[count.index].name
  location             = var.location
  resource_group_name  = var.resource_group_name

  dynamic "ip_configuration" {
    for_each = [for config in var.nic_configs[count.index].ip_configurations : {
      name                                    = config.name
      subnet_id                               = local.subnet_id_map[config.subnet_name]
      private_ip_address_allocation           = config.private_ip_address_allocation
      public_ip_address_id                    = lookup(config, "public_ip_address_id", null)
      private_ip_address                      = lookup(config, "private_ip_address", null)
      application_gateway_backend_address_pool_ids = lookup(config, "application_gateway_backend_address_pool_ids", null)
      load_balancer_backend_address_pool_ids  = lookup(config, "load_balancer_backend_address_pool_ids", null)
      load_balancer_inbound_nat_rules_ids     = lookup(config, "load_balancer_inbound_nat_rules_ids", null)
    }]
    content {
      name                                    = ip_configuration.value.name
      subnet_id                               = ip_configuration.value.subnet_id
      private_ip_address_allocation           = ip_configuration.value.private_ip_address_allocation
      public_ip_address_id                    = ip_configuration.value.public_ip_address_id
      private_ip_address                      = ip_configuration.value.private_ip_address
      application_gateway_backend_address_pool_ids = ip_configuration.value.application_gateway_backend_address_pool_ids
      load_balancer_backend_address_pool_ids  = ip_configuration.value.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids     = ip_configuration.value.load_balancer_inbound_nat_rules_ids
    }
  }
}
