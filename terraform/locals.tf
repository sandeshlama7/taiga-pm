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

    host_port                                    = 80
    container_port                               = 80
    container_name_1                             = "taiga-front"
    container_1_discovery_name                   = "taiga-front"
    container_port_1                             = 80
    host_port_1                                  = 80
    container_name_2                             = "taiga-back"
    container_2_discovery_name                   = "taiga-back"
    container_port_2                             = 8000
    host_port_2                                  = 8000
    container_name_3                             = "taiga-protected"
    container_3_discovery_name                   = "taiga-protected"
    container_port_3                             = 8003
    host_port_3                                  = 8003
    container_name_4                             = "taiga-events"
    container_4_discovery_name                   = "taiga-events"
    container_port_4                             = 8888
    host_port_4                                  = 8888
    container_name_5                             = "taiga-events-rabbitmq"
    container_5_discovery_name                   = "taiga-events-rabbitmq"
    container_port_5                             = 5672
    host_port_5                                  = 5672
    container_name_6                             = "taiga-async-rabbitmq"
    container_6_discovery_name                   = "taiga-async-rabbitmq"
    container_port_6                             = 5672
    host_port_6                                  = 5672
    container_name_7                             = "taiga-async"
    container_7_discovery_name                   = "taiga-async"
    container_port_7                             = 8000
    host_port_7                                  = 8000
    service_discovery_http_namespace_name        = "taiga-http-namespace-rabbitmq"
    service_discovery_private_dns_namespace_name = "taiga-pri-dns-namespace-rabbitmq"

    # postgres_host      = split(":", module.rds.db_instance_endpoint)[0]
    postgres_user      = "taiga"
    postgre_db         = "taiga_db"
    taiga_sites_scheme = "http"
    # taiga_sites_domain      = module.route53.route53_record_name
    taiga_subpath                 = ""
    email_backend                 = "django.core.mail.backends.console.EmailBackend"
    default_from_email            = "changeme@example.com"
    email_use_tls                 = "True"
    email_use_ssl                 = "False"
    email_host                    = "smtp.host.example.com"
    email_port                    = "587"
    email_host_user               = "user"
    rabbitmq_user                 = "taiga"
    enable_telemetry              = "True"
    public_register_enabled       = "True"
    front_public_register_enabled = "true"
    rabbitmq_default_user         = "taiga"
    rabbitmq_default_vhost        = "taiga"
    # taiga_secret_key        = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
  }

  # taiga_url           = "http://${local.ecs.taiga_sites_domain}"
  # taiga_websocket_url = "ws://${local.ecs.taiga_sites_domain}"

  taiga_sites_domain  = "taiga.sandbox.adex.ltd"
  taiga_url           = "http://taiga.sandbox.adex.ltd"
  taiga_websocket_url = "ws://taiga.sandbox.adex.ltd"

  ecs_service_taiga_async_rabbitmq = {
    name = "taiga-async-rabbitmq"
  }

  ecs_service_taiga_async = {
    name = "taiga-async"
  }

  ecs_service_taiga_back = {
    name = "taiga-back"
  }

  ecs_service_taiga_events_rabbitmq = {
    name = "taiga-events-rabbitmq"
  }

  ecs_service_taiga_events = {
    name = "taiga-events"
  }

  ecs_service_taiga_front = {
    name = "taiga-front"
  }

  ecs_service_taiga_protected = {
    name = "taiga-protected"
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
    engine_version           = "12.20"
    engine_lifecycle_support = "open-source-rds-extended-support-disabled"
    family                   = "postgres12" # DB parameter group
    major_engine_version     = "12"         # DB option group
    instance_class           = "db.t3.micro"

    allocated_storage           = 20
    max_allocated_storage       = 100
    db_name                     = "taiga_db"
    username                    = var.rds_username
    manage_master_user_password = false
    password                    = random_password.db_password.result
    port                        = 5432
    multi_az                    = var.rds_multi_az

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

  sm = {
    name                    = module.naming.resources.prefix.name
    description             = "Secret manager for storing credentials of rds and ecs"
    create                  = true
    enable_rotation         = false
    ignore_secret_changes   = false
    recovery_window_in_days = 0
  }

  random_password = {
    password_length     = 20
    exclude_punctuation = true
    include_space       = false
    special             = true
    override_special    = "_.-"
  }

  route53 = {
    zone_name = var.zone_name
    record    = "taiga"
  }

  tags = {
    environment = var.env
    application = var.application
    project     = var.project
    owner       = var.owner
  }

}
