#################################################
# data sources for the infrastructure
#################################################
data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

