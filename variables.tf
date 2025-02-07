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