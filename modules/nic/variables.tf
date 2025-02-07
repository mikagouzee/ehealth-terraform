variable "nic_name" {
  type = string
  description = "The network interface name"
}

variable "location" {
  type = string
  description = "The location used by the nic"
}

variable "resource_group_name" {
  type = string
  description = "The rg name"
}

variable "ip_configuration" {
  description = "Var for the IP configuration"
  type = object({
    name = string
    subnet_name = string
    private_ip_address_allocation = string
    public_ip_address_id = optional(string)
    private_ip_address = optional(string)
  })
  default = {
    name = "internal"
    subnet_name = "default_subnet_id"
    private_ip_address_allocation = "Dynamic"
  }
}

variable "subnet_ids" {
  description = "A map of subnet names to subnet IDs"
  type        = map(string)
}