variable "lb_name" {
  description = "Load Balancer name"
  type        = string
}

variable "location" {
  description = "Azure loacation"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "is_public" {
  description = "Define if the Load Balancer is private or puvlic"
  type        = bool
}

variable "public_ip_id" {
  description = "Public ID's IP if Load Balancer is public"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID if the Load Balancer is private"
  type        = string
  default     = null
}
