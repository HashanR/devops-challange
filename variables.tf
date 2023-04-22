variable "region" {
  description = "AWS region where the create resources"
  default     = "us-east-1"
}

variable "name" {
  description = "Org name"
  default     = "hub88"
}

variable "owner" {
  description = "Name of the owner"
  default     = "hashanr"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default = "10.161.0.0/24"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for the private subnets"
  default = [
  "10.161.0.0/27",
  "10.161.0.32/27",
  "10.161.0.64/27"
   ]
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
  default = [
  "10.161.0.128/27",
  "10.161.0.160/27",
  "10.161.0.192/27"
   ]
}

variable "environment" {
  type        = string
  description = "Environment name"
  default = "development"
}

variable "instance_type" {
    type = string
    description = "Type of the EC2 instances"
    default = "t2.micro"
  
}

variable "created_by_terraform" {
  type = bool
  description = "Infrastructure creation method"
  default = true
}

variable "public_key_name" {

    type = string
    description = "Name of the public key"
    default = "hub88-key"

  
}

variable "key_file" {

    type =  string
    description = "NName of the key file"
    default = "hub88-key"
  
}

variable "ssh_user" {
    type = string
    description = "Username that need to log into ubuntu instances"
    default = "ubuntu"
}