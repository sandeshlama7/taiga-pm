################################################################################
# VPC Module
################################################################################



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"



  create_vpc = local.vpc.create_vpc

  name = local.vpc.vpc_name
  cidr = local.vpc.vpc_cidr
  # region = var.region # Community module for vpc doesnot include region and region is used based upon what is mentioned in the provider file.

  azs              = local.vpc.azs
  private_subnets  = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 4, k)]
  database_subnets = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 4, k + 2)]
  public_subnets   = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 4, k + 4)]
  create_igw       = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_vpc            = false

  # VPC Flow Logs
  enable_flow_log = false

  tags = local.tags
}
