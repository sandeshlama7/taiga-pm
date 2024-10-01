#################################################
# data sources for the infrastructure
#################################################
data "aws_availability_zones" "available" {}

# data "aws_ecr_repository" "service" {
#   name = local.ecr.ecr_name
# }

data "aws_caller_identity" "current" {}

# data "aws_secretsmanager_secret" "taiga_secret" {
#   depends_on = [module.sm]
#   name       = local.sm.name
# }
