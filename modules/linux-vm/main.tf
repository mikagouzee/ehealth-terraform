resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids  = var.nic_id
  size                  = var.vm_size
  admin_username        = var.admin_username
  disable_password_authentication = false
  admin_password = "P@$$w0rd1234!" 

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

  # connection {
  #   type = var.connection.type
  #   host = var.connection.host
  #   user = var.connection.user
  #   password = var.connection.password
  # } 


  # provisioner "remote-exec" {
  #   inline = var.remote_exec.inline
  # }

}