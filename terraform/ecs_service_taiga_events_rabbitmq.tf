module "ecs_service_taiga_events_rabbitmq" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_events_rabbitmq.name
  cluster_arn = module.ecs.cluster_arn

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

          protocol = "tcp"
        }
      ]
      readonly_root_filesystem = false

      # hostname = "taiga-events-rabbitmq"

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
