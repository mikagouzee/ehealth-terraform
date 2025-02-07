variable "subnet_names" {
  description = "A list of subnets inside the vNet."
  type = list(string)
  default = ["public_subnet", "private_subnet", "db_subnet"]
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnets."
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "resource_group_name" {
  description = "Name of the resource group to be  "
}
variable "resource_group_location" {
  description = "Location of the resource group to be  "
}
