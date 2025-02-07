output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "container_names" {
  value = [for container in azurerm_storage_container.containers : container.name]
}

