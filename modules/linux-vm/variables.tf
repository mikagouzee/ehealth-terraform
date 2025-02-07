variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  default = "vm01"
}

variable "location" {
  description = "The location of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to attach the VM"
  type        = string
}

variable "public_ip_address_id" {
  description = "The ID of the public IP address"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the VM"
  type        = map(string)
  default     = {}
}

variable "os_disk" {
  type= object({
    name                  = string
    caching               = string
    storage_account_type  = string
  })

  description = "storage os disk input"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "admin_username" {
  type = string
  description = "admin username for the machine"
}

variable "nic_id" {
  type = list(string)
  description = "id of the network interface"
}

variable "password_auth" {
  type = bool
  description = "Enables password authentication"
}

variable "front_vm_username" {
  type = string
  description = "username for the front end machine"
  default = "azureuser"
}