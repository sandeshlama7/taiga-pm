module "ecs_service_taiga_protected" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_protected.name
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

    (local.ecs.container_name_3) = {
      essential = true
      image     = "${local.ecr_repository_url}:protected-latest"
      port_mappings = [
        {
          name          = local.ecs.container_name_3
          containerPort = local.ecs.container_port_3

          protocol = "tcp"
        }
      ]
      readonly_root_filesystem = false

      environment = [
        {
          name  = "ATTACHMENTS_MAX_AGE"
          value = 360
        }
      ]
      secrets = [
        {
          name      = "SECRET_KEY"
          valueFrom = "${module.sm.secret_arn}:TAIGA_SECRET_KEY::"
          # valueFrom = var.secret_test
          # valueFrom = random_password.taiga_secret.result
          # valueFrom = "secret password"
          # valueFrom = local.ecs.taiga_secret_key
          # valueFrom = "${data.aws_secretsmanager_secret.taiga_secret.arn}:TAIGA_SECRET_KEY::"
        }
      ]
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.ecs.container_port_3
        dns_name = local.ecs.container_name_3
      }
      port_name      = local.ecs.container_name_3
      discovery_name = local.ecs.container_3_discovery_name
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
