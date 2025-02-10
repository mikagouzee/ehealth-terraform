resource_group_name = "eHealth-rg"
resource_group_location = "West Europe"

front_vm_name = "ehealth-front"
front_vm_size = "Standard_DS1_v2"

back_vm_name = "ehealth-back"
back_vm_size = "Standard_DS1_v2"

subnet_names = ["public_subnet", "private_subnet", "db_subnet"]
subnet_prefixes      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]