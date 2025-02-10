variable "nic_ids" {
  description = "List of NIC IDs to be associated with the backend address pool"
  type        = list(string)
}

variable "ip_configuration_name" {
  description = "Name of the IP configuration"
  type        = string
}

variable "backend_address_pool_id" {
  description = "ID of the backend address pool"
  type        = string
}
