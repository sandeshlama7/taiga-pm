locals {
  vpc = {
    vpc_name   = module.naming.resources.vpc.name
    vpc_cidr   = var.vpc_cidr
    azs        = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
    create_vpc = var.vpc_id != "" && length(var.public_subnet_ids) != 0 && length(var.private_subnet_ids) != 0 ? false : true
  }

  region             = var.region
  vpc_id             = local.vpc.create_vpc != true ? var.vpc_id : module.vpc.vpc_id
  vpc_cidr           = local.vpc.create_vpc != true ? var.vpc_cidr : module.vpc.vpc_cidr_block
  public_subnet_ids  = local.vpc.create_vpc != true ? var.public_subnet_ids : module.vpc.public_subnets
  private_subnet_ids = local.vpc.create_vpc != true ? var.private_subnet_ids : module.vpc.private_subnets

  ecs = {
    ecs_cluster_name = module.naming.resources.ecs-cluster.name

    host_port        = 80
    container_port   = 80
    container_name_1 = "frontend"
    container_port_1 = 80
    host_port_1      = 80
    container_name_2 = "backend"
    container_port_2 = 8000
    host_port_2      = 8000
    container_name_3 = "protected"
    container_port_3 = 8003
    host_port_3      = 8003
    container_name_4 = "events"
    container_port_4 = 8888
    host_port_4      = 8888
    container_name_5 = "rabbitmq"
    container_port_5 = 5672
    host_port_5      = 5672

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

  ecr_repo       = split("/", "${module.ecr.repository_url}")[0]
  aws_account_id = data.aws_caller_identity.current.account_id
  # ecr_repository_url = data.aws_ecr_repository.service.repository_url
  ecr_repository_url = "${local.aws_account_id}.dkr.ecr.us-east-1.amazonaws.com/${local.ecr.ecr_name}"

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

  alb = {
    name                              = module.naming.resources.alb.name
    load_balancer_type                = "application"
    internal_load_balancer            = false
    enable_deletion_protection        = var.alb_enable_deletion_protection
    ecs_protocol                      = "HTTP"
    listener_port                     = 80
    listener_protocol                 = "HTTP"
    ecs_target_type                   = "ip"
    ecs_deregistration_delay          = 5
    load_balancing_cross_zone_enabled = true
  }

  rds = {
    identifier               = module.naming.resources.rds.name
    engine                   = "postgres"
    engine_version           = "14"
    engine_lifecycle_support = "open-source-rds-extended-support-disabled"
    family                   = "postgres14" # DB parameter group
    major_engine_version     = "14"         # DB option group
    instance_class           = "db.t3.micro"

    allocated_storage     = 20
    max_allocated_storage = 100
    db_name               = "taiga_db"
    username              = var.rds_username
    port                  = 5432
    multi_az              = var.rds_multi_az

    deletion_protection    = var.rds_deletion_protection
    create_db_subnet_group = true
    db_subnet_group_name   = local.vpc.create_vpc != true ? var.database_subnet_group_name : module.vpc.database_subnet_group
    skip_final_snapshot    = var.skip_final_snapshot

    monitoring_interval                    = var.rds_monitoring_interval
    monitoring_role_name                   = "${module.naming.resources.rds.name}-role"
    create_monitoring_role                 = var.create_monitoring_role
    parameter_group_name                   = "${module.naming.resources.rds.name}"
    parameter_group_use_name_prefix        = var.parameter_group_use_name_prefix
    iam_database_authentication_enabled    = false
    enabled_cloudwatch_logs_exports        = ["postgresql", "upgrade"]
    create_cloudwatch_log_group            = true
    cloudwatch_log_group_retention_in_days = 365

  }

  tags = {
    environment = var.env
    application = var.application
    project     = var.project
    owner       = var.owner
  }

}
