################################################################################
# terraform init vars
################################################################################

region             = "us-east-1"
env                = "dev"
naming_environment = "development"
application        = "taiga"
project            = "project_management"

vpc_cidr = "10.0.0.0/16"
# create_vpc         = false
vpc_id             = "vpc-03d964f7cd3fa2c74"
public_subnet_ids  = ["subnet-0f97b0bb45cdeb3b7", "subnet-0cd1b0c6e27ef5b97"]
private_subnet_ids = ["subnet-094222bc07bb63e74", "subnet-0a6f15fc861987834"]

number_of_azs = 2
