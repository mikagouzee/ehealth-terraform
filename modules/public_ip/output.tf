output "public_ip_id" {
    value = azurerm_public_ip.public_ip.id
}

output "address" {
  value = azurerm_public_ip.public_ip.ip_address
}