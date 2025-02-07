variable "resource_group_name" {
  type = string
  description = "RG name in Azure"
  default = "my-rg-default"
}

variable "resource_group_location" {
  type = string
  description = "rg location in azure"
  default = "my-rg-location-default"
}

variable "nsg_name" {
  type = string
  description = "rg location in azure"
  default = "my-nsg-default-name"
}

variable "nic_name" {
  type = string
  description = "nic name"
  default = "my_nic_default_name"
}

##FRONT END MACHINE##
variable "front_vm_size" {
  type = string
  description = "Size allocated to frontend VM"
  default = "Standard_DS1_v2"
}

variable "front_vm_name" {
  type = string
  default = "name of the front-facing machine"
}

variable "front_vm_username" {
  type = string
  description = "username for the front end machine"
  default = "azureuser"
}

##BACKEND MACHINE##
variable "back_vm_size" {
  type = string
  description = "Size allocated to backend VM"
  default = "Standard_DS1_v2"
}

variable "back_vm_name" {
  type = string
  default = "name of the back end machine"
}

variable "back_vm_username" {
  type = string
  description = "username for the back end machine"
  default = "azureuser"
}
