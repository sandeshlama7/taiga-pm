module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name = local.alb.name

  load_balancer_type = local.alb.load_balancer_type

  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }

  internal                   = local.alb.internal_load_balancer
  enable_deletion_protection = local.alb.enable_deletion_protection



  ### Listeners ###
  listeners = {
    http = {
      port     = local.alb.listener_port
      protocol = local.alb.listener_protocol

      forward = {
        target_group_key = "front_ecs"
        action_type      = "forward"
      }

      #   redirect = {
      #     port        = "443"
      #     protocol    = "HTTPS"
      #     status_code = "HTTP_301"
      #   }
    }
    # https = {
    #   port     = 443
    #   protocol = "HTTPS"
    #     certificate_arn = ""

    #   forward = {
    #     target_group_key = "front_ecs"
    #     action_type      = "forward"
    #   }
    # }
  }

  ### Target Group ###
  target_groups = {

    front_ecs = {
      protocol                          = local.alb.front_ecs_protocol
      port                              = local.ecs.container_port_1
      target_type                       = local.alb.front_ecs_target_type
      deregistration_delay              = local.alb.front_ecs_deregistration_delay
      load_balancing_cross_zone_enabled = local.alb.front_load_balancing_cross_zone_enabled

      health_check = {
        enabled = true
        # healthy_threshold   = 5
        interval = 60
        # matcher             = "200"
        # path                = "/"
        # port                = "traffic-port"
        # protocol            = "HTTP"
        # timeout             = 5
        # unhealthy_threshold = 2
      }
      create_attachment = false
    }
  }


}
