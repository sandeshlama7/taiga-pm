#######################################################################
# Defines the terraform state backend
########################################################################

terraform {
  backend "s3" {
    acl     = "bucket-owner-full-control"
    encrypt = true
  }
}
