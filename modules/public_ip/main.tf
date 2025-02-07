resource "azurerm_public_ip" "public_ip" {
    name = var.public_ip_name
    resource_group_name = var.resource_group_name
    location = var.resource_group_location
    allocation_method = "Dynamic"
}
