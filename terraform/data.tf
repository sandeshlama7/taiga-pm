#################################################
# data sources for the infrastructure
#################################################
data "aws_availability_zones" "available" {}

# data "aws_ecr_repository" "service" {
#   name = local.ecr.ecr_name
# }

data "aws_caller_identity" "current" {}

# data "aws_secretsmanager_secret" "taiga_secret" {
#   arn = module.sm.secret_arn
# }

# data "aws_secretsmanager_secret_version" "secret_version" {
#   secret_id = data.aws_secretsmanager_secret.taiga_secret.id
# }

data "aws_route53_zone" "route53_zone" {
  name         = "sandbox.adex.ltd"
  private_zone = false
}
