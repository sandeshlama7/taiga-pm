################################################################################
# Cluster
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.11.4"

  cluster_name = local.ecs.ecs_cluster_name

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

      cpu          = 1024
      memory       = 4096
      network_mode = "awsvpc"

      # Enables ECS Exec this helps in interacting with containers directly
      enable_execute_command = true

      subnet_ids = local.private_subnet_ids

      # Container definition(s)
      container_definitions = {

        (local.ecs.container_name_1) = {
          essential = true
          image     = "${local.ecr_repository_url}:front-latest"
          port_mappings = [
            {
              name          = local.ecs.container_name_1
              containerPort = local.ecs.container_port_1
              hostPort      = local.ecs.host_port
              protocol      = "tcp"
            }
          ]

          readonly_root_filesystem = false
        }
      }

      security_group_rules = {
        alb_ingress_80 = {
          type        = "ingress"
          from_port   = local.ecs.container_port
          to_port     = local.ecs.container_port_1
          protocol    = "tcp"
          description = "Service port"
          # source_security_group_id = module.alb.security_group_id
          cidr_blocks = ["0.0.0.0/0"]
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["front_ecs"].arn
          container_name   = local.ecs.container_name_1
          container_port   = local.ecs.container_port_1
        }
      }
    }
  }

  tags = local.tags
}
