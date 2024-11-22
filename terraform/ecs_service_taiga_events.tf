module "ecs_service_taiga_events" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_events.name
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

    (local.ecs.container_name_4) = {
      essential = true
      image     = "${local.ecr_repository_url}:events-latest"
      port_mappings = [
        {
          name          = local.ecs.container_name_4
          containerPort = local.ecs.container_port_4

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

      environment = [
        {
          name  = "RABBITMQ_USER"
          value = local.ecs.rabbitmq_default_user
        },
        {
          name  = "TAIGA_EVENTS_RABBITMQ_HOST"
          value = "taiga-events-rabbitmq.local"
        }
      ]

      secrets = [
        {
          name      = "RABBITMQ_PASS"
          valueFrom = "${module.sm.secret_arn}:RABBITMQ_PASS::"
        },
        {
          name      = "TAIGA_SECRET_KEY"
          valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
        }
      ]
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.ecs.container_port_4
        dns_name = local.ecs.container_name_4
      }
      port_name      = local.ecs.container_name_4
      discovery_name = local.ecs.container_4_discovery_name
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
