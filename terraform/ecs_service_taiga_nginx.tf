module "ecs_service_taiga_nginx" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.11.2"
  create  = true

  name        = local.ecs_service_taiga_nginx.name
  cluster_arn = module.ecs.cluster_arn

  cpu          = 256
  memory       = 512
  network_mode = "awsvpc"

  # Enables ECS Exec this helps in interacting with containers directly
  enable_execute_command = true

  wait_for_steady_state = true

  subnet_ids            = local.private_subnet_ids
  create_security_group = false
  security_group_ids    = [aws_security_group.asg_sg_ecs.id]

  # Container definition(s)
  container_definitions = {

    (local.ecs.container_name_8) = {
      essential = true
      image     = "${local.ecr_repository_url}:nginx-latest"
      port_mappings = [
        {
          name          = local.ecs.container_name_8
          containerPort = local.ecs.container_port_8

          protocol = "tcp"
        }
      ]
      readonly_root_filesystem = false

      mount_points = [
        {
          sourceVolume  = "taiga-static-data"
          containerPath = "/taiga/static" #Path where EFS will be mounted inside the container
          readOnly      = false
        },
        {
          sourceVolume  = "taiga-media-data"
          containerPath = "/taiga/media" #Path where EFS will be mounted inside the container
          readOnly      = false
        }
      ]

      command = [
        "sh",
        "-c",
        <<EOT
        sed -i 's/nginx;/root;/' /etc/nginx/nginx.conf &&
        echo 'server {
          listen 80 default_server;
          client_max_body_size 100M;
          charset utf-8;
          location /static/ {
            alias /taiga/static/;
          }
          location /_protected/ {
            internal;
            alias /taiga/media/;
            add_header Content-disposition "attachment";
          }
          location /media/exports/ {
            alias /taiga/media/exports/;
            add_header Content-disposition "attachment";
          }
          location /media/ {
              proxy_set_header Host $http_host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Scheme $scheme;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_pass http://taiga-protected:8003/;
              proxy_redirect off;
          }
        }' > /etc/nginx/conf.d/default.conf && 
        nginx -g 'daemon off;'
        EOT
      ]
    }
  }

  volume = {
    ("taiga-static-data") = {
      efs_volume_configuration = {
        file_system_id = module.efs.id
        # root_directory     = "/" # This argument is ignored when using authorization_config
        transit_encryption = "ENABLED"
        authorization_config = {
          access_point_id = module.efs.access_points.taiga-static-data.id
          iam             = "ENABLED"
        }
      }
    }
    ("taiga-media-data") = {
      efs_volume_configuration = {
        file_system_id = module.efs.id
        # root_directory     = "/" # This argument is ignored when using authorization_config
        transit_encryption = "ENABLED"
        authorization_config = {
          access_point_id = module.efs.access_points.taiga-media-data.id
          iam             = "ENABLED"
        }
      }
    }
  }

  service_connect_configuration = {
    namespace = aws_service_discovery_http_namespace.this.arn
    service = {
      client_alias = {
        port     = local.ecs.container_port_8
        dns_name = local.ecs.container_name_8
      }
      port_name      = local.ecs.container_name_8
      discovery_name = local.ecs.container_8_discovery_name
    }
  }

  load_balancer = {
    service_8 = {
      target_group_arn = module.alb.target_groups["nginx_ecs"].arn
      container_name   = local.ecs.container_name_8
      container_port   = local.ecs.container_port_8
    }
  }
}
