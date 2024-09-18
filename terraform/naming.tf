module "naming" {
  source = "git@github.com:adexltd/terraform-naming-convention-module.git"

  app_name       = "taiga"
  project_prefix = "pm-infra"
  app_name_short = "taiga"
  aws_region     = var.region
  environment    = var.naming_environment
  tags = {
    environment = var.naming_environment
    project     = "adex-suite"
    terraform   = true
  }
}
