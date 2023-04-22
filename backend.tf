# terraform {
#   backend "s3" {
#     region = "us-east-1"
#     bucket = "hub88-terraform-remote"
#     key    = "terraform.tfstate"
    

#     dynamodb_table = "hub88-terraform-state-lock"
#     encrypt        = true

#   }
# }

## I've commented out remote backend if you need to reproduce this project it will be easy otherwise you will need to create bucket and dynamo db table but as a best practices we use remote state
