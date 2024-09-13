locals {
  short_region = {
    "us-east-1"      = "ue1"
    "us-east-2"      = "ue2"
    "us-west-1"      = "uw1"
    "us-west-2"      = "uw2"
    "eu-west-1"      = "euw1"
    "eu-west-2"      = "euw2"
    "eu-central-1"   = "ecw1"
    "ca-central-1"   = "cc1"
    "ap-south-1"     = "as1"
    "ap-southeast-1" = "ase1"
    "ap-southeast-2" = "ase1"
    "ap-northeast-1" = "an1"
    "ap-northeast-2" = "an2"
  }

  short_resource_function = {
    "application" = "ap"
    "database"    = "db"
  }

  short_env_type = {
    "production"  = "p"
    "development" = "d"
    "stage"       = "s"
    "uat"         = "u"
    "qa"          = "q"
    "test"        = "t"
  }

  short_aws_services = {
    "ec2"                    = "ec2"
    "lt"                     = "lt"
    "asg"                    = "asg"
    "alb"                    = "alb"
    "nlb"                    = "nlb"
    "tg"                     = "tg"
    "ecs-cluster"            = "ecs-cluster"
    "ecs-service"            = "svc"
    "ecs-task"               = "task"
    "efs"                    = "efs"
    "iam-role"               = "role"
    "iam-policy"             = "policy"
    "kms"                    = "kms"
    "sg"                     = "sg"
    "opensearch"             = "opnsrch"
    "rds"                    = "rds"
    "rds-serverless"         = "rds-sles"
    "s3"                     = "s3"
    "code-artifact"          = "artifactory"
    "sns"                    = "sns"
    "cloudtrail"             = "trial"
    "lambda"                 = "lmbd"
    "dynamodb"               = "dynamo"
    "vpc"                    = "vpc"
    "sqs"                    = "sqs"
    "eks-cluster"            = "ekscluster"
    "eks-node-group"         = "eks-ng"
    "waf"                    = "waf"
    "guardduty-filter"       = "gd-filter"
    "cloudwatch-dashboard"   = "cw-dash"
    "data-lifecycle-manager" = "dlm"
  }

  inner_service_name = {
    ec2 = join((var.delimiter), [local.short_region[var.aws_region], var.app_name_short, local.short_resource_function[var.resource_function]])
  }

  # Defaults
  delimiter = var.delimiter

  # App prefix
  prefix = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment]])

  # Final naming convention
  ec2                    = join(local.delimiter, [var.project_prefix, local.inner_service_name.ec2, local.short_env_type[var.environment], local.short_aws_services.ec2])
  lt                     = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.lt])
  asg                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.asg])
  alb                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.alb])
  nlb                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.nlb])
  tg                     = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.tg])
  ecr                    = join("/", [var.project_prefix, var.app_name_short])
  ecs-cluster            = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.ecs-cluster])
  ecs-service            = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], local.short_env_type[var.environment], local.short_aws_services.ecs-service, var.app_name])
  ecs-task               = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], local.short_env_type[var.environment], local.short_aws_services.ecs-task, var.app_name])
  efs                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.efs])
  iam-role               = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.iam-role])
  iam-policy             = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.iam-policy])
  kms                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.kms])
  sg                     = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.sg])
  opensearch             = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.opensearch])
  rds-serverless         = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.rds-serverless])
  rds                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.rds])
  s3                     = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.s3])
  code-artifact          = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.code-artifact])
  sns                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.sns])
  cloudtrail             = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.cloudtrail])
  lambda                 = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.lambda])
  dynamodb               = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.dynamodb])
  vpc                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], local.short_env_type[var.environment], local.short_aws_services.vpc])
  sqs                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.sqs])
  eks-cluster            = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.eks-cluster])
  eks-node-group         = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.eks-node-group])
  waf                    = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.waf])
  guardduty-filter       = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.guardduty-filter])
  cloudwatch-dashboard   = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.cloudwatch-dashboard])
  data-lifecycle-manager = join(local.delimiter, [var.project_prefix, local.short_region[var.aws_region], var.app_name_short, local.short_env_type[var.environment], local.short_aws_services.data-lifecycle-manager])


  # Tags that should be implemented on each resource created for the project
  # Tags should be defined at the aws provider level
  shared_tags = {
    environment   = lower(var.environment)
    region        = lower(var.aws_region)
    application   = lower(var.app_name)
    applicationId = lower(var.app_name_short)
    createdBy     = "terraform"
  }

  tags = merge(local.shared_tags, var.tags)
}
