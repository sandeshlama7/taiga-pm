module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.9.0"

  identifier               = local.rds.identifier
  engine                   = local.rds.engine
  engine_version           = local.rds.engine_version
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = local.rds.family               # DB parameter group
  major_engine_version     = local.rds.major_engine_version # DB option group
  instance_class           = local.rds.instance_class

  allocated_storage           = local.rds.allocated_storage
  max_allocated_storage       = local.rds.max_allocated_storage
  db_name                     = local.rds.db_name
  username                    = local.rds.username
  manage_master_user_password = local.rds.manage_master_user_password
  password                    = local.rds.password
  port                        = local.rds.port
  multi_az                    = local.rds.multi_az

  subnet_ids             = local.private_subnet_ids
  vpc_security_group_ids = [aws_security_group.database.id]
  deletion_protection    = local.rds.deletion_protection
  create_db_subnet_group = local.rds.create_db_subnet_group
  db_subnet_group_name   = local.rds.db_subnet_group_name
  skip_final_snapshot    = local.rds.skip_final_snapshot
  apply_immediately      = true

  monitoring_interval                    = local.rds.monitoring_interval
  monitoring_role_name                   = local.rds.monitoring_role_name
  create_monitoring_role                 = local.rds.create_monitoring_role
  parameter_group_name                   = local.rds.parameter_group_name
  parameter_group_use_name_prefix        = local.rds.parameter_group_use_name_prefix
  iam_database_authentication_enabled    = local.rds.iam_database_authentication_enabled
  enabled_cloudwatch_logs_exports        = local.rds.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = local.rds.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = local.rds.cloudwatch_log_group_retention_in_days

  tags = local.tags
}
