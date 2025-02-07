module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  # File system
  name           = local.efs.name
  creation_token = local.efs.name
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
      sid = "Acess EFS by ECS cluster"
      actions = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite"
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

    taiga-static-data = {
      name = "taiga-static-data"
      root_directory = { # Root directory is used to determine what ownership to give if no such folder exists
        path = "/taiga-static-data"
        creation_info = {
          owner_gid   = 1001 # Nginx is running with gid and uid 101 which can be seen using 'id nginx' in terminal
          owner_uid   = 1001
          permissions = "750"
        }
      }
      # posix_user = { # Posix user is used to determine which user can perform read/ write operations.
      #   gid = 101
      #   uid = 101
      # }
    }

    taiga-media-data = {
      name = "taiga-media-data"
      root_directory = {
        path = "/taiga-media-data"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "750"
        }
      }
    }

    taiga-async-rabbitmq-data = {
      name = "taiga-async-rabbitmq-data"
      root_directory = {
        path = "/taiga-async-rabbitmq-data"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "750"
        }
      }
    }
    taiga-events-rabbitmq-data = {
      name = "taiga-events-rabbitmq-data"
      root_directory = {
        path = "/taiga-events-rabbitmq-data"
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
