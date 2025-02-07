variable "public_ip_name" {
    description = "The public IP name"
    type = string
}

variable "allocation_method" {
    description = "The public IP address allocation method"
    type = string
}

variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
}

variable "resource_group_location" {
    description = "The location of the resource group"
    type        = string
}