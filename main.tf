############################################################
#                         VPC                              #
############################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"

  name = "${var.name}"
  cidr = var.vpc_cidr

  azs = ["${var.region}a", "${var.region}b", "${var.region}c"]

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # Enable creation of a NAT Gateway and ensure only a single NAT Gateway is created
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = var.created_by_terraform
    Environment = var.environment
    Owner       = var.owner
  }
}





