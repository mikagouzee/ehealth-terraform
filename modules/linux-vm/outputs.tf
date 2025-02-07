output "vm_id" {
  description = "The ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

# output "public_ip_address" {
#   description = "The public IP address of the virtual machine"
#   value       = azurerm_public_ip.pip.ip_address
# }

output "publicIPs"{
  description = "public ip of the machine"
  value = local.public_ip_map
}
