################################################################################
# Defines the terraform local variables
################################################################################

locals {
  endpoints = { for k, v in var.endpoints : k => v if var.create && try(v.create, true) }

  security_group_ids = var.create && var.create_security_group ? concat(var.security_group_ids, [aws_security_group.this[0].id]) : var.security_group_ids
}
