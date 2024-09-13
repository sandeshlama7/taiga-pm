locals {
  vpc = {
    vpc_name           = module.naming.resources.vpc.name
    vpc_cidr           = var.vpc_cidr
    azs                = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
    create_vpc         = var.vpc_id != "" && length(var.public_subnet_ids) != 0 && length(var.private_subnet_ids) != 0 ? false : true
    vpc_id             = var.vpc_id
    public_subnet_ids  = var.public_subnet_ids
    private_subnet_ids = var.private_subnet_ids
  }

  ecs = {
    cluster_name = module.naming.resources.ecs-cluster.name
  }

  # load_balancer = {
  #   vpc_id = local.vpc.create_vpc != false ? module.vpc.vpc_id : local.vpc.vpc_id
  # }

  tags = {
    Environment = var.env
    Application = var.application
    Project     = var.project
  }

}
