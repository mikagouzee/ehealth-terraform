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

variable "front_instances" {
  type = number
  description = "Amount of frontend VM to create"
}

variable "back_instances" {
  type = number
  description = "Amount of backend VM to create"
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

variable "public_ip_name" {
  type = string
  description = "Public ip name in azure"
  default = "my-public-ip-default"
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

variable "subnet_names" {
  description = "Liste des noms des sous-réseaux"
  type        = list(string)
  # default     = ["subnet1", "subnet2", "subnet3"]
}

variable "subnet_prefixes" {
  description = "Liste des préfixes des sous-réseaux"
  type        = list(string)
  # default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
