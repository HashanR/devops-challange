############################################################
#             Application Load Balancer                    #
############################################################
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.name}-alb"

  load_balancer_type           = "application"
  load_balancer_create_timeout = "60m"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb-sg.id]


  target_groups = [
    {
      name_prefix      = "${var.name}-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        web-server-1 = {
          target_id = aws_instance.web-server.*.id[0]
          port      = 80
        }

        web-server-2 = {
          target_id = aws_instance.web-server.*.id[1]
          port      = 80
        }

        web-server-3 = {
          target_id = aws_instance.web-server.*.id[2]
          port      = 80
        }

      }
    }
  ]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]


  tags = {
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }

}



resource "aws_security_group" "alb-sg" {
  name_prefix = "${var.name}-alb-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }


  tags = {
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }
}