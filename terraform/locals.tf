locals {
  vpc = {
    vpc_name   = module.naming.resources.vpc.name
    vpc_cidr   = var.vpc_cidr
    azs        = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
    create_vpc = var.vpc_id != "" && length(var.public_subnet_ids) != 0 && length(var.private_subnet_ids) != 0 ? false : true
  }

  vpc_id             = local.vpc.create_vpc != true ? var.vpc_id : module.vpc.vpc_id
  public_subnet_ids  = local.vpc.create_vpc != true ? var.public_subnet_ids : module.vpc.public_subnets
  private_subnet_ids = local.vpc.create_vpc != true ? var.private_subnet_ids : module.vpc.private_subnets

  tags = {
    Environment = var.env
    Application = var.application
    Project     = var.project
  }

}
