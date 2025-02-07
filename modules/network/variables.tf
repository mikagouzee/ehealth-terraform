variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the resource group"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "subnet_names" {
  description = "The names of the subnets"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "The address prefixes for the subnets"
  type        = list(string)
}

variable "nic_configs" {
  description = "Configuration for the network interfaces"
  type = list(object({
    name              = string
    ip_configurations = list(object({
      name                                    = string
      subnet_name                             = string
      private_ip_address_allocation           = string
      public_ip_address_id                    = optional(string)
      private_ip_address                      = optional(string)
      application_gateway_backend_address_pool_ids = optional(list(string))
      load_balancer_backend_address_pool_ids  = optional(list(string))
      load_balancer_inbound_nat_rules_ids     = optional(list(string))
    }))
  }))
}
