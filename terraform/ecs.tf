################################################################################
# Cluster
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = local.ecs.ecs_cluster_name

  depends_on = [null_resource.push_to_ecr_with_tag]

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

  services = {
    taiga-frontend-service = {

      cpu          = 512
      memory       = 2048
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids            = local.private_subnet_ids
      create_security_group = false
      security_group_ids    = [aws_security_group.asg_sg_ecs.id]

      # Container definition(s)
      container_definitions = {

        (local.ecs.container_name_1) = {
          essential = true
          # image     = "${module.ecr.repository_url}:front-latest"
          # image     = "${local.ecr_repository_url}:front-latest"
          image = "${local.ecr_repository_url}:front-latest"
          port_mappings = [
            {
              name          = local.ecs.container_name_1
              containerPort = local.ecs.container_port_1
              hostPort      = local.ecs.host_port_1
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = false

          environment = [
            {
              name  = "TAIGA_URL"
              value = "http://pm-infra-ue1-taiga-d-alb-12345.us-east-1.elb.amazonaws.com"
            },
            {
              name  = "TAIGA_WEBSOCKETS_URL"
              value = "ws://pm-infra-ue1-taiga-d-alb-12345.us-east-1.elb.amazonaws.com"
            },
            {
              name  = "TAIGA_SUBPATH"
              value = ""
            },
            {
              name  = "PUBLIC_REGISTER_ENABLED"
              value = "true"
            }
          ]
        }
      }
      load_balancer = {
        service_1 = {
          target_group_arn = module.alb.target_groups["front_ecs"].arn
          container_name   = local.ecs.container_name_1
          container_port   = local.ecs.container_port_1
        }
      }
    }

    taiga-backend-service = {

      cpu          = 2048
      memory       = 4096
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids            = local.private_subnet_ids
      create_security_group = false
      security_group_ids    = [aws_security_group.asg_sg_ecs.id]

      # Container definition(s)
      container_definitions = {

        (local.ecs.container_name_2) = {
          essential = true
          image     = "${local.ecr_repository_url}:back-latest"
          port_mappings = [
            {
              name          = local.ecs.container_name_2
              containerPort = local.ecs.container_port_2
              hostPort      = local.ecs.host_port_2
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = false

          environment = [
            {
              name  = "POSTGRES_DB"
              value = "taiga_db"
            },
            {
              name  = "POSTGRES_USER"
              value = "taiga"
            },
            {
              name  = "POSTGRES_PASSWORD"
              value = "Zp#6EGN[bGE$"
            },
            {
              name  = "POSTGRES_HOST"
              value = "pm-infra-ue1-taiga-d-rds.12345.us-east-1.rds.amazonaws.com"
            },
            {
              name  = "TAIGA_SECRET_KEY"
              value = "This-is-a-very-secret-key-with-Base64-encoding"
            },
            {
              name  = "TAIGA_SITES_SCHEME"
              value = "http"
            },
            {
              name  = "TAIGA_SITES_DOMAIN"
              value = "pm-infra-ue1-taiga-d-alb-12345.us-east-1.elb.amazonaws.com"
            },
            {
              name  = "TAIGA_SUBPATH"
              value = ""
            },
            {
              name  = "EMAIL_BACKEND"
              value = "django.core.mail.backends.console.EmailBackend"
            },
            {
              name  = "DEFAULT_FROM_EMAIL"
              value = "changeme@example.com"
            },
            {
              name  = "EMAIL_USE_TLS"
              value = "True"
            },
            {
              name  = "EMAIL_USE_SSL"
              value = "False"
            },
            {
              name  = "EMAIL_HOST"
              value = "smtp.host.example.com"
            },
            {
              name  = "EMAIL_PORT"
              value = "587"
            },
            {
              name  = "EMAIL_HOST_USER"
              value = "user"
            },
            {
              name  = "EMAIL_HOST_PASSWORD"
              value = "password"
            },
            {
              name  = "RABBITMQ_USER"
              value = "taiga"
            },
            {
              name  = "RABBITMQ_PASS"
              value = "taiga"
            },
            {
              name  = "ENABLE_TELEMETRY"
              value = "True"
            },
            {
              name  = "PUBLIC_REGISTER_ENABLED"
              value = "True"
            }
          ]
        }
      }
      load_balancer = {
        service_2 = {
          target_group_arn = module.alb.target_groups["back_ecs_api_admin"].arn
          container_name   = local.ecs.container_name_2
          container_port   = local.ecs.container_port_2
        }
      }
    }

    taiga-protected-service = {

      cpu          = 1024
      memory       = 2048
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids            = local.private_subnet_ids
      create_security_group = false
      security_group_ids    = [aws_security_group.asg_sg_ecs.id]

      # Container definition(s)
      container_definitions = {

        (local.ecs.container_name_3) = {
          essential = true
          image     = "${local.ecr_repository_url}:protected-latest"
          port_mappings = [
            {
              name          = local.ecs.container_name_3
              containerPort = local.ecs.container_port_3
              hostPort      = local.ecs.host_port_3
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = false

          environment = [
            {
              name  = "SECRET_KEY"
              value = "This-is-a-very-secret-key-with-Base64-encoding"
            },
            {
              name  = "ATTACHMENTS_MAX_AGE"
              value = 360
            }
          ]
        }
      }
      load_balancer = {
        service_4 = {
          target_group_arn = module.alb.target_groups["media_ecs_protected_unprotected"].arn
          container_name   = local.ecs.container_name_3
          container_port   = local.ecs.container_port_3
        }
      }
    }

    taiga-events-service = {

      cpu          = 512
      memory       = 2048
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids            = local.private_subnet_ids
      create_security_group = false
      security_group_ids    = [aws_security_group.asg_sg_ecs.id]

      # Container definition(s)
      container_definitions = {

        (local.ecs.container_name_4) = {
          essential = true
          image     = "${local.ecr_repository_url}:events-latest"
          port_mappings = [
            {
              name          = local.ecs.container_name_4
              containerPort = local.ecs.container_port_4
              hostPort      = local.ecs.host_port_4
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = false

          environment = [
            {
              name  = "RABBITMQ_USER"
              value = "taiga"
            },
            {
              name  = "RABBITMQ_PASS"
              value = "taiga"
            },
            {
              name  = "TAIGA_SECRET_KEY"
              value = "This-is-a-very-secret-key-with-Base64-encoding"
            }
          ]
        }
      }
      load_balancer = {
        service_6 = {
          target_group_arn = module.alb.target_groups["events_ecs"].arn
          container_name   = local.ecs.container_name_4
          container_port   = local.ecs.container_port_4
        }
      }
    }

    taiga-rabbitmq-service = {

      cpu          = 512
      memory       = 1024
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids            = local.private_subnet_ids
      create_security_group = false
      security_group_ids    = [aws_security_group.asg_sg_ecs.id]

      # Container definition(s)
      container_definitions = {

        (local.ecs.container_name_5) = {
          essential = true
          image     = "${local.ecr_repository_url}:rabbitmq-latest"
          port_mappings = [
            {
              name          = local.ecs.container_name_5
              containerPort = local.ecs.container_port_5
              hostPort      = local.ecs.host_port_5
              protocol      = "tcp"
            }
          ]
          readonly_root_filesystem = false
          environment = [
            {
              name  = "RABBITMQ_ERLANG_COOKIE"
              value = "This-is-a-very-secret-erlang-cookie-with-Base64-encoding"
            },
            {
              name  = "RABBITMQ_DEFAULT_USER"
              value = "taiga"
            },
            {
              name  = "RABBITMQ_DEFAULT_PASS"
              value = "taiga"
            },
            {
              name  = "RABBITMQ_DEFAULT_VHOST"
              value = "taiga"
            }
          ]
        }
      }

      service_connect_configuration = {
        namespace = aws_service_discovery_http_namespace.this.arn
        service = {
          client_alias = {
            port     = local.ecs.container_port_5
            dns_name = local.ecs.container_name_5
          }
          port_name      = local.ecs.container_name_5
          discovery_name = local.ecs.container_5_discovery_name
        }
      }
    }
  }

  tags = local.tags
}


################################################################################
# Supporting Resources
################################################################################

resource "aws_service_discovery_http_namespace" "this" {
  name        = local.ecs.service_discovery_namespace_name
  description = "CloudMap namespace for ${local.ecs.service_discovery_namespace_name}"
  tags        = local.tags
}
