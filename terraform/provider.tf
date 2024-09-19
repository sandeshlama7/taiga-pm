################################################################################
# Defines the resources provider
################################################################################

provider "aws" {
  region = var.region
  default_tags {
    tags = module.naming.default_tags
  }
}
