variable "lb_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "frontendIpConfig" {
    type = object({
        name                 = string
        public_ip_address_id = optional(string)
        private_ip_address = optional(string)
        private_ip_address_allocation = optional(string)
    })
}

