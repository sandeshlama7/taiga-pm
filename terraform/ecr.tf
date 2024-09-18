#ECR with KMS encryption
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.3.0"

  repository_name = local.ecr.ecr_name

  repository_type                 = local.ecr.ecr_repository_type
  repository_image_tag_mutability = local.ecr.image_tag_mutability
  repository_force_delete         = local.ecr.ecr_force_delete
  repository_encryption_type      = local.ecr.encryption_type
  repository_image_scan_on_push   = local.ecr.scan_on_push
  create_lifecycle_policy         = local.ecr.create_lifecycle_policy

  tags = local.tags

}
