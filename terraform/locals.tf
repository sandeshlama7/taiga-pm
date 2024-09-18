locals {
  vpc = {
    vpc_name   = module.naming.resources.vpc.name
    vpc_cidr   = var.vpc_cidr
    azs        = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
    create_vpc = var.vpc_id != "" && length(var.public_subnet_ids) != 0 && length(var.private_subnet_ids) != 0 ? false : true
  }

  vpc_id             = local.vpc.create_vpc != true ? var.vpc_id : module.vpc.vpc_id
  vpc_cidr           = local.vpc.create_vpc != true ? var.vpc_cidr : module.vpc.vpc_cidr_block
  public_subnet_ids  = local.vpc.create_vpc != true ? var.public_subnet_ids : module.vpc.public_subnets
  private_subnet_ids = local.vpc.create_vpc != true ? var.private_subnet_ids : module.vpc.private_subnets

  ecs = {
    ecs_cluster_name = module.naming.resources.ecs-cluster.name

    nginx_container_name = "nginx"
    nginx_container_port = 80
    nginx_host_port      = 80
    container_port       = 80
  }

  ecr = {
    ecr_name                = module.naming.resources.ecr.name
    ecr_repository_type     = "private"
    image_tag_mutability    = "IMMUTABLE"
    ecr_force_delete        = var.ecr_force_delete
    encryption_type         = "AES256"
    scan_on_push            = var.ecr_scan_on_push
    create_lifecycle_policy = false
  }

  ecr_repository_url = data.aws_ecr_repository.service.repository_url


  efs = {
    efs_name                           = module.naming.resources.efs.name
    encrypted                          = true
    attach_policy                      = true
    bypass_policy_lockout_safety_check = false
    security_group_vpc_id              = local.vpc_id
    security_group_description         = "EFS security group"
    security_group_cidr_block          = local.vpc_cidr
    efs_backup_policy                  = true
  }

  tags = {
    Environment = var.env
    Application = var.application
    Project     = var.project
    Owner       = var.owner
  }

}
