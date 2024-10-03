module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.11.0"

  name = local.alb.name

  load_balancer_type = local.alb.load_balancer_type
  vpc_id             = local.vpc_id
  subnets            = local.public_subnet_ids

  security_groups            = [aws_security_group.alb_sg.id]
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
      #   }    # Path-based routing rules
      rules = [
        {
          actions = [{
            type             = "forward"
            target_group_key = "back_ecs_api_admin"
          }]

          conditions = [{
            path_pattern = {
              values = ["/api/*", "/admin/*"]
            }
          }]
        },
        # {
        #   actions = [{
        #     type             = "forward"
        #     target_group_key = "back_ecs_admin"
        #   }]
        #   conditions = [{
        #     path_pattern = {
        #       values = ["/admin/*"]
        #     }
        #   }]
        # },
        # {
        #   actions = [{
        #     type             = "forward"
        #     target_group_key = "media_ecs_unprotected"
        #   }]
        #   conditions = [{
        #     path_pattern = {
        #       values = ["/media/exports/*"]
        #     }
        #   }]
        # },
        {
          actions = [{
            type             = "forward"
            target_group_key = "media_ecs_protected_unprotected"
          }]
          conditions = [{
            path_pattern = {
              values = ["/media/exports/*", "/media/*"]
            }
          }]
        },
        {
          actions = [{
            type             = "forward"
            target_group_key = "events_ecs"
          }]
          conditions = [{
            path_pattern = {
              values = ["/events"]
            }
          }]
        }
      ]
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
      protocol                          = local.alb.ecs_protocol
      port                              = local.ecs.container_port_1
      target_type                       = local.alb.ecs_target_type
      deregistration_delay              = local.alb.ecs_deregistration_delay
      load_balancing_cross_zone_enabled = local.alb.load_balancing_cross_zone_enabled

      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 120
        matcher             = "200-499"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 10
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

    back_ecs_api_admin = {
      protocol                          = local.alb.ecs_protocol
      port                              = 8000
      target_type                       = local.alb.ecs_target_type
      deregistration_delay              = local.alb.ecs_deregistration_delay
      load_balancing_cross_zone_enabled = local.alb.load_balancing_cross_zone_enabled
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 120
        matcher             = "200-499"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 30
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

    # back_ecs_admin = {
    #   protocol    = local.alb.ecs_protocol
    #   port        = 8000
    #   target_type = local.alb.ecs_target_type
    #   deregistration_delay              = local.alb.ecs_deregistration_delay
    #   load_balancing_cross_zone_enabled = local.alb.load_balancing_cross_zone_enabled
    #   health_check = {
    #     enabled = true
    #     healthy_thres1old   = 5
    #     interval = 120
    #     matcher             = "200-499"
    #     path                = "/"
    #     port                = "traffic-port"
    #     protocol            = "HTTP"
    #     timeout             = 30
    #     unhealthy_threshold = 2
    #   }
    #   create_attachment = false
    # }

    media_ecs_protected_unprotected = {
      protocol                          = local.alb.ecs_protocol
      port                              = 8003
      target_type                       = local.alb.ecs_target_type
      deregistration_delay              = local.alb.ecs_deregistration_delay
      load_balancing_cross_zone_enabled = local.alb.load_balancing_cross_zone_enabled
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 120
        matcher             = "200-499"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 30
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

    # media_ecs_unprotected = {
    #   protocol    = local.alb.ecs_protocol
    #   port        = 8003
    #   target_type = local.alb.ecs_target_type
    #   deregistration_delay              = local.alb.ecs_deregistration_delay
    #   load_balancing_cross_zone_enabled = local.alb.load_balancing_cross_zone_enabled
    #   health_check = {
    #     enabled = true
    #     healthy_thres1old   = 5
    #     interval = 120
    #     matcher             = "200-499"
    #     path                = "/"
    #     port                = "traffic-port"
    #     protocol            = "HTTP"
    #     timeout             = 30
    #     unhealthy_threshold = 2
    #   }
    #   create_attachment = false
    # }

    events_ecs = {
      protocol                          = local.alb.ecs_protocol
      port                              = 8888
      target_type                       = local.alb.ecs_target_type
      deregistration_delay              = local.alb.ecs_deregistration_delay
      load_balancing_cross_zone_enabled = local.alb.load_balancing_cross_zone_enabled
      health_check = {
        enabled             = true
        healthy_threshold   = 2
        interval            = 120
        matcher             = "200-499"
        path                = "/events"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 30
        unhealthy_threshold = 2
      }
      create_attachment = false
    }

  }


}
