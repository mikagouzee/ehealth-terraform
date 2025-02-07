resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.nic_id
  size                  = var.vm_size
  admin_username        = var.admin_username
  disable_password_authentication = var.password_auth
  

  os_disk {
    name              = var.os_disk.name
    caching           = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }
  
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  
  tags = var.tags
}

locals {
  public_ip_map = {for nicid in azurerm_linux_virtual_machine.vm.network_interface_ids: nicid.name => nicid.id }
}