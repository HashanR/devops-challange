############################################################
#                      Bation Server                       #
############################################################
resource "aws_instance" "bastion_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnets[2]
  security_groups = [aws_security_group.bastion_server_sg.id]
  key_name        = var.public_key_name
  
  # Use user_data to bootstrap the EC2 instance with SSH key and Ansible
  user_data = <<-EOF
              #!/bin/bash
              echo "${file(var.key_file)}" > /home/ubuntu/.ssh/id_rsa
              chown ubuntu /home/ubuntu/.ssh/id_rsa
              chgrp ubuntu /home/ubuntu/.ssh/id_rsa
              chmod 600 /home/ubuntu/.ssh/id_rsa
              sudo apt-get update -y
              sudo apt-get install ansible -y
              EOF

  depends_on = [
    local_file.local_key
  ]

  tags = {
    Name        = "${var.name}-bastion-server"
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }

}

resource "aws_security_group" "bastion_server_sg" {
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
resource "aws_instance" "web_server" {
  count           = length(module.vpc.private_subnets)
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  subnet_id       = module.vpc.private_subnets[count.index]
  security_groups = [aws_security_group.web_servers_sg.id]
  key_name        = var.public_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  depends_on = [
    local_file.local_key
  ]

  tags = {
    Name        = format("${var.name}-web-server-%02d", count.index + 1)
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }

}

resource "aws_security_group" "web_servers_sg" {
  name_prefix = "${var.name}-web-servers-sg-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_server_sg.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
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
resource "aws_key_pair" "key_pair" {
  key_name   = var.public_key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.key_file
}

