module "ecs_service_taiga_async" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_async.name
  cluster_arn = module.ecs.cluster_arn

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

    (local.ecs.container_name_7) = {
      essential = true
      image     = "${local.ecr_repository_url}:back-latest"
      port_mappings = [
        {
          name          = local.ecs.container_name_7
          containerPort = local.ecs.container_port_7

          protocol = "tcp"
        }
      ]
      readonly_root_filesystem = false

      # dependencies = [
      #   {
      #   containerName = local.ecs.container_name_5
      #   condition = "START"
      #   }
      # ]

      entrypoint = ["/taiga-back/docker/async_entrypoint.sh"]

      environment = [
        {
          name  = "POSTGRES_DB"
          value = local.ecs.postgre_db
        },
        {
          name  = "POSTGRES_USER"
          value = local.ecs.postgres_user
        },
        {
          name  = "TAIGA_SITES_SCHEME"
          value = local.ecs.taiga_sites_scheme
        },
        {
          name  = "TAIGA_SITES_DOMAIN"
          value = local.taiga_sites_domain
        },
        {
          name  = "TAIGA_SUBPATH"
          value = local.ecs.taiga_subpath
        },
        {
          name  = "EMAIL_BACKEND"
          value = local.ecs.email_backend
        },
        {
          name  = "DEFAULT_FROM_EMAIL"
          value = local.ecs.default_from_email
        },
        {
          name  = "EMAIL_USE_TLS"
          value = local.ecs.email_use_tls
        },
        {
          name  = "EMAIL_USE_SSL"
          value = local.ecs.email_use_ssl
        },
        {
          name  = "EMAIL_HOST"
          value = local.ecs.email_host
        },
        {
          name  = "EMAIL_PORT"
          value = local.ecs.email_port
        },
        {
          name  = "EMAIL_HOST_USER"
          value = local.ecs.email_host_user
        },
        {
          name  = "RABBITMQ_USER"
          value = local.ecs.rabbitmq_user
        },
        {
          name  = "ENABLE_TELEMETRY"
          value = local.ecs.enable_telemetry
        },
        {
          name  = "PUBLIC_REGISTER_ENABLED"
          value = local.ecs.public_register_enabled
        }
      ]

      secrets = [
        {
          name      = "POSTGRES_HOST"
          valueFrom = "${module.sm.secret_arn}:POSTGRES_HOST::"
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = "${module.sm.secret_arn}:POSTGRES_PASSWORD::"
        },
        {
          name      = "TAIGA_SECRET_KEY"
          valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
        },
        {
          name      = "EMAIL_HOST_PASSWORD"
          valueFrom = "${module.sm.secret_arn}:EMAIL_HOST_PASSWORD::"
        },
        {
          name      = "RABBITMQ_PASS"
          valueFrom = "${module.sm.secret_arn}:RABBITMQ_PASS::"
        }
      ]
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.ecs.container_port_7
        dns_name = local.ecs.container_name_7
      }
      port_name      = local.ecs.container_name_7
      discovery_name = local.ecs.container_7_discovery_name
    }
  }

  # load_balancer = {
  #   service_2 = {
  #     target_group_arn = module.alb.target_groups["back_ecs_api_admin"].arn
  #     container_name   = local.ecs.container_name_2
  #     container_port   = local.ecs.container_port_2
  #   }
  # }
}
