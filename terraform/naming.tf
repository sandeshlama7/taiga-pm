module "naming" {
  source = "./modules/terraform-naming-convention-module"

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
