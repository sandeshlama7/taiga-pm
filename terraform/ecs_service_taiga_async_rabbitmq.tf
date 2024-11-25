module "ecs_service_taiga_async_rabbitmq" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_async_rabbitmq.name
  cluster_arn = module.ecs.cluster_arn

  cpu          = 512
  memory       = 1024
  network_mode = "awsvpc"

  # Enables ECS Exec this helps in interacting with containers directly
  enable_execute_command = true

  wait_for_steady_state = true

  subnet_ids            = local.private_subnet_ids
  create_security_group = false
  security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  # Container definition(s)
  container_definitions = {

    (local.ecs.container_name_6) = {
      essential = true
      image     = "${local.ecr_repository_url}:rabbitmq-latest"
      port_mappings = [
        {
          name          = local.ecs.container_name_6
          containerPort = local.ecs.container_port_6

          protocol = "tcp"
        },
        {
          name          = "a"
          containerPort = 4369
          protocol      = "tcp"
        },
        {
          name          = "b"
          containerPort = 5671
          protocol      = "tcp"
        },
        {
          name          = "c"
          containerPort = 15671
          protocol      = "tcp"
        },
        {
          name          = "d"
          containerPort = 15672
          protocol      = "tcp"
        },
        {
          name          = "e"
          containerPort = 15691
          protocol      = "tcp"
        },
        {
          name          = "f"
          containerPort = 15692
          protocol      = "tcp"
        },
        {
          name          = "g"
          containerPort = 25672
          protocol      = "tcp"
        }
      ]
      readonly_root_filesystem = false

      environment = [
        {
          name  = "RABBITMQ_DEFAULT_USER"
          value = local.ecs.rabbitmq_default_user
        },
        {
          name  = "RABBITMQ_DEFAULT_VHOST"
          value = local.ecs.rabbitmq_default_vhost
        }
      ]

      secrets = [
        {
          name      = "RABBITMQ_ERLANG_COOKIE"
          valueFrom = "${module.sm.secret_arn}:RABBITMQ_ERLANG_COOKIE::"
        },
        {
          name      = "RABBITMQ_DEFAULT_PASS"
          valueFrom = "${module.sm.secret_arn}:RABBITMQ_PASS::"
        }
      ]
      mount_points = [
        {
          sourceVolume  = "taiga-async-rabbitmq-data"
          containerPath = "/var/lib/rabbitmq" #Path where EFS will be mounted inside the container
          readOnly      = false
        }
      ]
    }
  }

  volume = {
    ("taiga-async-rabbitmq-data") = {
      efs_volume_configuration = {
        file_system_id = module.efs.id
        # root_directory     = "/" # This argument is ignored when using authorization_config
        transit_encryption = "ENABLED"
        authorization_config = {
          access_point_id = module.efs.access_points.taiga-async-rabbitmq-data.id
          iam             = "ENABLED"
        }
      }
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.ecs.container_port_6
        dns_name = local.ecs.container_name_6
      }
      port_name      = local.ecs.container_name_6
      discovery_name = local.ecs.container_6_discovery_name
    }
  }
}
