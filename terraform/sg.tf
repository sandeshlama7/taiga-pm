########################ALB#################################
resource "aws_security_group" "alb_sg" {
  name        = "alb"
  description = "Allow traffic to alb"
  vpc_id      = local.vpc_id

  # HTTP rule
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS rule
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################ECS#################################
resource "aws_security_group" "asg_sg_ecs" {
  name        = "ecs sg"
  description = "Allow traffic to ecs from alb"
  vpc_id      = local.vpc_id

  # # HTTP rule
  # ingress {
  #   from_port       = 80
  #   to_port         = 80
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  # ingress {
  #   from_port       = 8000
  #   to_port         = 8000
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  # ingress {
  #   from_port       = 8003
  #   to_port         = 8003
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  # ingress {
  #   from_port       = 8888
  #   to_port         = 8888
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]
  # }

  # # HTTPS rule
  # ingress {
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.alb_sg.id]

  # HTTPS rule
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # security_groups = [aws_security_group.alb_sg.id]
    cidr_blocks = ["0.0.0.0/0"]

  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################################
#########          RDS Configuration          ##############
############################################################

resource "aws_security_group" "database" {
  description = "Security group for database"
  vpc_id      = local.vpc_id

  # PGsql Inbound rule
  ingress {
    description     = "TLS from VPC"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.asg_sg_ecs.id]
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
