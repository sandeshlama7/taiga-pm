################################################################################
# terraform init vars
################################################################################

region             = "us-east-1"
env                = "dev"
naming_environment = "development"
application        = "taiga"
project            = "project_management"
owner              = "sameep"

vpc_cidr = "10.0.0.0/16"
# create_vpc         = false
vpc_id             = "vpc-03d964f7cd3fa2c74"
public_subnet_ids  = ["subnet-0f97b0bb45cdeb3b7", "subnet-0cd1b0c6e27ef5b97"]
private_subnet_ids = ["subnet-094222bc07bb63e74", "subnet-0a6f15fc861987834"]

number_of_azs = 2


ecr_force_delete = true
ecr_scan_on_push = false

alb_enable_deletion_protection = false

rds_username                    = "taiga"
rds_multi_az                    = true
rds_deletion_protection         = false
database_subnet_group_name      = "taiga_db_subnet_group"
skip_final_snapshot             = true
rds_monitoring_interval         = 0
create_monitoring_role          = false
parameter_group_use_name_prefix = false
