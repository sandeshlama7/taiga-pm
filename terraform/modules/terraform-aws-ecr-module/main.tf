
################################################################################
# Private Repository
################################################################################

resource "aws_ecr_repository" "this" {
  count                = local.create_private_repository ? 1 : 0
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}


################################################################################
# Public Repository
################################################################################

resource "aws_ecrpublic_repository" "this" {
  count           = local.create_public_repository ? 1 : 0
  repository_name = var.name
}



################################################################################
# Policy for Private Repo
################################################################################

resource "aws_ecr_repository_policy" "this" {
  count      = local.create_private_repository && var.policy != null ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = var.policy
}


################################################################################
# Policy for Public Repo
################################################################################
resource "aws_ecrpublic_repository_policy" "this" {
  count           = var.public_policy == null ? 0 : 1
  repository_name = aws_ecrpublic_repository.this[0].repository_name
  policy          = var.public_policy
}


################################################################################
# Lifecycle Policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.lifecycle_policy == null ? 0 : 1
  repository = aws_ecr_repository.this[0].name
  policy     = var.lifecycle_policy
}
