resource "azurerm_network_interface" "nic" {
  name = var.nic_name
  location = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {    
    name = var.ip_configuration.name
    subnet_id = var.subnet_ids[var.ip_configuration.subnet_name]
    private_ip_address_allocation = var.ip_configuration.private_ip_address_allocation
    public_ip_address_id = lookup(var.ip_configuration, "public_ip_address_id", null)
    private_ip_address = lookup(var.ip_configuration, "private_ip_address", null)
  }


}