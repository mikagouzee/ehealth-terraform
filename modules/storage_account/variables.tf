variable "storage_account_name" {
  description = "Storage Account name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "container_names" {
  description = "List of Blob Containers name"
  type        = list(string)
}

