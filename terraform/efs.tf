module "efs" {
  source = "./modules/terraform-aws-efs-module"

  # File system
  name           = local.efs.efs_name
  creation_token = local.efs.efs_name
  encrypted      = local.efs.encrypted

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"


  lifecycle_policy = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  ## File system policy
  attach_policy                      = local.efs.attach_policy
  bypass_policy_lockout_safety_check = local.efs.bypass_policy_lockout_safety_check
  policy_statements = [
    {
      sid = "Example"
      actions = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess"
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
    }
  ]


  # Mount targets / security group
  mount_targets = { for k, v in zipmap(local.vpc.azs, local.private_subnet_ids) : k => { subnet_id = v } }
  #   mount_targets = {
  #     "us-east-1a" = {
  #       subnet_id = local.private_subnet_ids[0]
  #     }
  #     "us-east-1b" = {
  #       subnet_id = local.private_subnet_ids[1]
  #     }
  #   }
  security_group_description = local.efs.security_group_description
  security_group_vpc_id      = local.efs.security_group_vpc_id
  security_group_rules = {
    vpc = {
      description = local.efs.security_group_description
      cidr_blocks = [local.efs.security_group_cidr_block]
    }
  }


  # Access point(s)
  access_points = {
    rabbitmq_access = {
      name = "rabbitmq-access"
      root_directory = {
        path = "/rabbitmq"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "750"
        }
      }
    }
  }


  # Backup policy
  enable_backup_policy = local.efs.efs_backup_policy

  tags = local.tags
}
