module "ecs_service_taiga_front" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_front.name
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

    (local.ecs.container_name_1) = {
      essential = true
      image     = "${local.ecr_repository_url}:front-latest"
      port_mappings = [
        {
          name          = local.ecs.container_name_1
          containerPort = local.ecs.container_port_1

          protocol = "tcp"
        }
      ]
      readonly_root_filesystem = false

      environment = [
        {
          name  = "TAIGA_URL"
          value = local.taiga_url
        },
        {
          name  = "TAIGA_WEBSOCKETS_URL"
          value = local.taiga_websocket_url
        },
        {
          name  = "TAIGA_SUBPATH"
          value = ""
        },
        {
          name  = "PUBLIC_REGISTER_ENABLED"
          value = local.ecs.front_public_register_enabled
        }
      ]
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.ecs.container_port_1
        dns_name = local.ecs.container_name_1
      }
      port_name      = local.ecs.container_name_1
      discovery_name = local.ecs.container_1_discovery_name
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
