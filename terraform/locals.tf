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

  ecs = {
    ecs_cluster_name = module.naming.resources.ecs-cluster.name
    ecs_service_name = module.naming.resources.ecs-service.name

    nginx_container_name = "nginx"
    nginx_container_port = 80
    nginx_host_port      = 80

    container_port = 80
  }

  ecr = {
    ecr_name             = module.naming.resources.ecr.name
    ecr_repository_type  = "private"
    image_tag_mutability = "IMMUTABLE"
    ecr_force_delete     = var.ecr_force_delete
    encryption_type      = "KMS"
    scan_on_push         = var.ecr_scan_on_push
  }

  tags = {
    Environment = var.env
    Application = var.application
    Project     = var.project
    Owner       = var.owner
  }

}
