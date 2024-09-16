locals {
  create_private_repository = var.create && var.repository_type == "private"
  create_public_repository  = var.create && var.repository_type == "public"
}
