################################################################################
# Cluster
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = local.ecs.ecs_cluster_name

  depends_on = [module.sm, null_resource.push_to_ecr_with_tag]

  # Capacity provider
  # Allocate 20% capacity to FARGATE and then split the remaining 80% capacity to 50/50 between FARGATE and FARGATE_SPOT
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
        base   = 0
      }
    }
  }

  # services = {

  #   taiga-back = {

  #     cpu          = 1024
  #     memory       = 2048
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_2) = {
  #         essential = true
  #         image     = "${local.ecr_repository_url}:back-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_2
  #             containerPort = local.ecs.container_port_2

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         # dependencies = [
  #         #   {
  #         #   containerName = local.ecs.container_name_5
  #         #   condition = "START"
  #         #   }
  #         # ]

  #         environment = [
  #           {
  #             name  = "POSTGRES_DB"
  #             value = local.ecs.postgre_db
  #           },
  #           {
  #             name  = "POSTGRES_USER"
  #             value = local.ecs.postgres_user
  #           },
  #           {
  #             name  = "TAIGA_SITES_SCHEME"
  #             value = local.ecs.taiga_sites_scheme
  #           },
  #           {
  #             name  = "TAIGA_SITES_DOMAIN"
  #             value = local.taiga_sites_domain
  #           },
  #           {
  #             name  = "TAIGA_SUBPATH"
  #             value = local.ecs.taiga_subpath
  #           },
  #           {
  #             name  = "EMAIL_BACKEND"
  #             value = local.ecs.email_backend
  #           },
  #           {
  #             name  = "DEFAULT_FROM_EMAIL"
  #             value = local.ecs.default_from_email
  #           },
  #           {
  #             name  = "EMAIL_USE_TLS"
  #             value = local.ecs.email_use_tls
  #           },
  #           {
  #             name  = "EMAIL_USE_SSL"
  #             value = local.ecs.email_use_ssl
  #           },
  #           {
  #             name  = "EMAIL_HOST"
  #             value = local.ecs.email_host
  #           },
  #           {
  #             name  = "EMAIL_PORT"
  #             value = local.ecs.email_port
  #           },
  #           {
  #             name  = "EMAIL_HOST_USER"
  #             value = local.ecs.email_host_user
  #           },
  #           {
  #             name  = "RABBITMQ_USER"
  #             value = local.ecs.rabbitmq_user
  #           },
  #           {
  #             name  = "ENABLE_TELEMETRY"
  #             value = local.ecs.enable_telemetry
  #           },
  #           {
  #             name  = "PUBLIC_REGISTER_ENABLED"
  #             value = local.ecs.public_register_enabled
  #           }
  #         ]

  #         secrets = [
  #           {
  #             name      = "POSTGRES_HOST"
  #             valueFrom = "${module.sm.secret_arn}:POSTGRES_HOST::"
  #           },
  #           {
  #             name      = "POSTGRES_PASSWORD"
  #             valueFrom = "${module.sm.secret_arn}:POSTGRES_PASSWORD::"
  #           },
  #           {
  #             name      = "TAIGA_SECRET_KEY"
  #             valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
  #           },
  #           {
  #             name  = "EMAIL_HOST_PASSWORD"
  #             value = "${module.sm.secret_arn}:EMAIL_HOST_PASSWORD::"
  #           },
  #           {
  #             name      = "RABBITMQ_PASS"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_PASS::"
  #           }
  #         ]
  #       }
  #     }

  #     service_connect_configuration = {
  #       namespace = aws_service_discovery_http_namespace.this.arn
  #       service = {
  #         client_alias = {
  #           port     = local.ecs.container_port_2
  #           dns_name = local.ecs.container_name_2
  #         }
  #         port_name      = local.ecs.container_name_2
  #         discovery_name = local.ecs.container_2_discovery_name
  #       }
  #     }

  #     load_balancer = {
  #       service_2 = {
  #         target_group_arn = module.alb.target_groups["back_ecs_api_admin"].arn
  #         container_name   = local.ecs.container_name_2
  #         container_port   = local.ecs.container_port_2
  #       }
  #     }
  #   }

  #   taiga-async = {

  #     cpu          = 1024
  #     memory       = 2048
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_7) = {
  #         essential = true
  #         image     = "${local.ecr_repository_url}:back-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_7
  #             containerPort = local.ecs.container_port_7

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         # dependencies = [
  #         #   {
  #         #   containerName = local.ecs.container_name_5
  #         #   condition = "START"
  #         #   }
  #         # ]

  #         # entrypoint = ["/taiga-back/docker/async_entrypoint.sh"]

  #         environment = [
  #           {
  #             name  = "POSTGRES_DB"
  #             value = local.ecs.postgre_db
  #           },
  #           {
  #             name  = "POSTGRES_USER"
  #             value = local.ecs.postgres_user
  #           },
  #           {
  #             name  = "TAIGA_SITES_SCHEME"
  #             value = local.ecs.taiga_sites_scheme
  #           },
  #           {
  #             name  = "TAIGA_SITES_DOMAIN"
  #             value = local.taiga_sites_domain
  #           },
  #           {
  #             name  = "TAIGA_SUBPATH"
  #             value = local.ecs.taiga_subpath
  #           },
  #           {
  #             name  = "EMAIL_BACKEND"
  #             value = local.ecs.email_backend
  #           },
  #           {
  #             name  = "DEFAULT_FROM_EMAIL"
  #             value = local.ecs.default_from_email
  #           },
  #           {
  #             name  = "EMAIL_USE_TLS"
  #             value = local.ecs.email_use_tls
  #           },
  #           {
  #             name  = "EMAIL_USE_SSL"
  #             value = local.ecs.email_use_ssl
  #           },
  #           {
  #             name  = "EMAIL_HOST"
  #             value = local.ecs.email_host
  #           },
  #           {
  #             name  = "EMAIL_PORT"
  #             value = local.ecs.email_port
  #           },
  #           {
  #             name  = "EMAIL_HOST_USER"
  #             value = local.ecs.email_host_user
  #           },
  #           {
  #             name  = "RABBITMQ_USER"
  #             value = local.ecs.rabbitmq_user
  #           },
  #           {
  #             name  = "ENABLE_TELEMETRY"
  #             value = local.ecs.enable_telemetry
  #           },
  #           {
  #             name  = "PUBLIC_REGISTER_ENABLED"
  #             value = local.ecs.public_register_enabled
  #           }
  #         ]

  #         secrets = [
  #           {
  #             name      = "POSTGRES_HOST"
  #             valueFrom = "${module.sm.secret_arn}:POSTGRES_HOST::"
  #           },
  #           {
  #             name      = "POSTGRES_PASSWORD"
  #             valueFrom = "${module.sm.secret_arn}:POSTGRES_PASSWORD::"
  #           },
  #           {
  #             name      = "TAIGA_SECRET_KEY"
  #             valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
  #           },
  #           {
  #             name  = "EMAIL_HOST_PASSWORD"
  #             value = "${module.sm.secret_arn}:EMAIL_HOST_PASSWORD::"
  #           },
  #           {
  #             name      = "RABBITMQ_PASS"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_PASS::"
  #           }
  #         ]
  #       }
  #     }
  #     # load_balancer = {
  #     #   service_2 = {
  #     #     target_group_arn = module.alb.target_groups["back_ecs_api_admin"].arn
  #     #     container_name   = local.ecs.container_name_2
  #     #     container_port   = local.ecs.container_port_2
  #     #   }
  #     # }
  #   }

  #   taiga-async-rabbitmq = {

  #     cpu          = 512
  #     memory       = 1024
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_6) = {
  #         essential = true
  #         image     = "${local.ecr_repository_url}:rabbitmq-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_6
  #             containerPort = local.ecs.container_port_6

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         # hostname = "taiga-async-rabbitmq"

  #         environment = [
  #           {
  #             name  = "RABBITMQ_DEFAULT_USER"
  #             value = local.ecs.rabbitmq_default_user
  #           },
  #           {
  #             name  = "RABBITMQ_DEFAULT_VHOST"
  #             value = local.ecs.rabbitmq_default_vhost
  #           }
  #         ]

  #         secrets = [
  #           {
  #             name      = "RABBITMQ_ERLANG_COOKIE"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_ERLANG_COOKIE::"
  #           },
  #           {
  #             name      = "RABBITMQ_DEFAULT_PASS"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_DEFAULT_PASS::"
  #           }
  #         ]
  #       }
  #     }

  #     service_connect_configuration = {
  #       namespace = aws_service_discovery_http_namespace.this.arn
  #       service = {
  #         client_alias = {
  #           port     = local.ecs.container_port_6
  #           dns_name = local.ecs.container_name_6
  #         }
  #         port_name      = local.ecs.container_name_6
  #         discovery_name = local.ecs.container_6_discovery_name
  #       }
  #     }
  #   }

  #   taiga-front = {

  #     cpu          = 512
  #     memory       = 1024
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_1) = {
  #         essential = true
  #         # image     = "${module.ecr.repository_url}:front-latest"
  #         # image     = "${local.ecr_repository_url}:front-latest"
  #         image = "${local.ecr_repository_url}:front-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_1
  #             containerPort = local.ecs.container_port_1

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         environment = [
  #           {
  #             name  = "TAIGA_URL"
  #             value = local.taiga_url
  #           },
  #           {
  #             name  = "TAIGA_WEBSOCKETS_URL"
  #             value = local.taiga_websocket_url
  #           },
  #           {
  #             name  = "TAIGA_SUBPATH"
  #             value = ""
  #           },
  #           {
  #             name  = "PUBLIC_REGISTER_ENABLED"
  #             value = local.ecs.public_register_enabled
  #           }
  #         ]
  #       }
  #     }
  #     load_balancer = {
  #       service_1 = {
  #         target_group_arn = module.alb.target_groups["front_ecs"].arn
  #         container_name   = local.ecs.container_name_1
  #         container_port   = local.ecs.container_port_1
  #       }
  #     }
  #   }

  #   taiga-events = {

  #     cpu          = 512
  #     memory       = 1024
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_4) = {
  #         essential = true
  #         image     = "${local.ecr_repository_url}:events-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_4
  #             containerPort = local.ecs.container_port_4

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         # dependencies = [
  #         #   {
  #         #   containerName = local.ecs.container_name_5
  #         #   condition = "START"
  #         #   }
  #         # ]

  #         environment = [
  #           {
  #             name  = "RABBITMQ_USER"
  #             value = local.ecs.rabbitmq_default_user
  #           }
  #         ]

  #         secrets = [
  #           {
  #             name      = "RABBITMQ_PASS"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_DEFAULT_PASS::"
  #           },
  #           {
  #             name      = "TAIGA_SECRET_KEY"
  #             valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
  #           }
  #         ]
  #       }
  #     }
  #     load_balancer = {
  #       service_6 = {
  #         target_group_arn = module.alb.target_groups["events_ecs"].arn
  #         container_name   = local.ecs.container_name_4
  #         container_port   = local.ecs.container_port_4
  #       }
  #     }
  #   }

  #   taiga-events-rabbitmq = {

  #     cpu          = 512
  #     memory       = 1024
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_5) = {
  #         essential = true
  #         image     = "${local.ecr_repository_url}:rabbitmq-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_5
  #             containerPort = local.ecs.container_port_5

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         # hostname = "taiga-events-rabbitmq"

  #         environment = [
  #           {
  #             name  = "RABBITMQ_DEFAULT_USER"
  #             value = local.ecs.rabbitmq_default_user
  #           },
  #           {
  #             name  = "RABBITMQ_DEFAULT_VHOST"
  #             value = local.ecs.rabbitmq_default_vhost
  #           }
  #         ]

  #         secrets = [
  #           {
  #             name      = "RABBITMQ_ERLANG_COOKIE"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_ERLANG_COOKIE::"
  #           },
  #           {
  #             name      = "RABBITMQ_DEFAULT_PASS"
  #             valueFrom = "${module.sm.secret_arn}:RABBITMQ_DEFAULT_PASS::"
  #           }
  #         ]
  #       }
  #     }

  #     service_connect_configuration = {
  #       namespace = aws_service_discovery_http_namespace.this.arn
  #       service = {
  #         client_alias = {
  #           port     = local.ecs.container_port_5
  #           dns_name = local.ecs.container_name_5
  #         }
  #         port_name      = local.ecs.container_name_5
  #         discovery_name = local.ecs.container_5_discovery_name
  #       }
  #     }
  #   }

  #   taiga-protected = {

  #     cpu          = 512
  #     memory       = 1024
  #     network_mode = "awsvpc"

  #     # Enables ECS Exec this helps in interacting with containers directly
  #     enable_execute_command = true

  #     subnet_ids            = local.private_subnet_ids
  #     create_security_group = false
  #     security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  #     # Container definition(s)
  #     container_definitions = {

  #       (local.ecs.container_name_3) = {
  #         essential = true
  #         image     = "${local.ecr_repository_url}:protected-latest"
  #         port_mappings = [
  #           {
  #             name          = local.ecs.container_name_3
  #             containerPort = local.ecs.container_port_3

  #             protocol = "tcp"
  #           }
  #         ]
  #         readonly_root_filesystem = false

  #         environment = [
  #           {
  #             name  = "ATTACHMENTS_MAX_AGE"
  #             value = 360
  #           }
  #         ]
  #         secrets = [
  #           {
  #             name      = "SECRET_KEY"
  #             valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
  #             # valueFrom = var.secret_test
  #             # valueFrom = random_password.taiga_secret.result
  #             # valueFrom = "secret password"
  #             # valueFrom = local.ecs.taiga_secret_key
  #             # valueFrom = "${data.aws_secretsmanager_secret.taiga_secret.arn}:TAIGA_SECRET_KEY::"
  #           }
  #         ]
  #       }
  #     }
  #     load_balancer = {
  #       service_4 = {
  #         target_group_arn = module.alb.target_groups["media_ecs_protected_unprotected"].arn
  #         container_name   = local.ecs.container_name_3
  #         container_port   = local.ecs.container_port_3
  #       }
  #     }
  #   }
  # }

  # tags = local.tags
}


################################################################################
# Supporting Resources
################################################################################

resource "aws_service_discovery_http_namespace" "this" {
  name        = local.ecs.service_discovery_http_namespace_name
  description = "CloudMap namespace for ${local.ecs.service_discovery_http_namespace_name}"
  tags        = local.tags
}
