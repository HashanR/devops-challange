############################################################
#                      Bation Server                       #
############################################################
resource "aws_instance" "bastion-server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnets[2]
  security_groups = [aws_security_group.bastion-server-sg.id]

  tags = {
    Name        = "${var.name}-bastion_server"
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }

}

resource "aws_security_group" "bastion-server-sg" {
  name_prefix = "${var.name}-bastion-server-sg-"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }
}

############################################################
#                      Web Server                          #
############################################################
resource "aws_instance" "web-server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  count           = length(module.vpc.private_subnets)
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.web-servers-sg.id]

  tags = {
    Name = format("${var.name}-web-server-%02d", count.index + 1)
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }

}

resource "aws_security_group" "web-servers-sg" {
  name_prefix = "${var.name}-web-servers-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-server-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }
}
