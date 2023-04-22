############################################################
#                      Bation Server                       #
############################################################
resource "aws_instance" "bastion-server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnets[2]
  security_groups = [aws_security_group.bastion-server-sg.id]
  key_name        = var.public_key_name

  tags = {
    Name        = "${var.name}-bastion-server"
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
  count           = length(module.vpc.private_subnets)
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.web-servers-sg.id]
  key_name        = var.public_key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<html><body><h1>Hello from $(hostname)</h1></body></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = format("${var.name}-web-server-%02d", count.index + 1)
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

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
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
#                      SSH Key Pair                        #
############################################################
resource "aws_key_pair" "key-pair" {
  key_name   = var.public_key_name
  public_key = tls_private_key.rsa.public_key_openssh


}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.key_file
}

