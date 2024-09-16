#ECR with KMS encryption
module "ecr" {
  source = "./modules/terraform-aws-ecr-module"

  name = local.ecr.ecr_name

  repository_type      = local.ecr.ecr_repository_type
  image_tag_mutability = local.ecr.image_tag_mutability
  force_delete         = local.ecr.ecr_force_delete
  encryption_type      = local.ecr.encryption_type
  scan_on_push         = local.ecr.scan_on_push

  tags = local.tags

}
