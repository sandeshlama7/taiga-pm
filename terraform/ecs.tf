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

      cpu          = 4096
      memory       = 8192
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids = local.private_subnet_ids

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
        }

        (local.ecs.container_name_2) = {
          essential = false
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
        }

        (local.ecs.container_name_3) = {
          essential = false
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
        }

        (local.ecs.container_name_4) = {
          essential = false
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
        }

        (local.ecs.container_name_5) = {
          essential = false
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
        }
      }

      security_group_ids = [aws_security_group.asg_sg_ecs.id]

      load_balancer = {
        service_1 = {
          target_group_arn = module.alb.target_groups["front_ecs"].arn
          container_name   = local.ecs.container_name_1
          container_port   = local.ecs.container_port_1
        }

        service_2 = {
          target_group_arn = module.alb.target_groups["back_ecs_api_admin"].arn
          container_name   = local.ecs.container_name_2
          container_port   = local.ecs.container_port_2
        }

        # service_3 = {
        #   target_group_arn = module.alb.target_groups["back_ecs_admin"].arn
        #   container_name   = local.ecs.container_name_2
        #   container_port   = local.ecs.container_port_2
        # }

        service_4 = {
          target_group_arn = module.alb.target_groups["media_ecs_protected_unprotected"].arn
          container_name   = local.ecs.container_name_3
          container_port   = local.ecs.container_port_3
        }
        # service_5 = {
        #   target_group_arn = module.alb.target_groups["media_ecs_unprotected"].arn
        #   container_name   = local.ecs.container_name_3
        #   container_port   = local.ecs.container_port_3
        # }
        service_6 = {
          target_group_arn = module.alb.target_groups["events_ecs"].arn
          container_name   = local.ecs.container_name_4
          container_port   = local.ecs.container_port_4
        }
      }
    }
  }

  tags = local.tags
}
