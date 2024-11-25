#################################################
# data sources for the infrastructure
#################################################
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "route53_zone" {
  name         = "sandbox.adex.ltd"
  private_zone = false
}
