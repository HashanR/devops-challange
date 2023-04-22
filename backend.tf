terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "hub88-terraform-remote"
    key    = "terraform.tfstate"
    

    dynamodb_table = "hub88-terraform-state-lock"
    encrypt        = true

  }
}