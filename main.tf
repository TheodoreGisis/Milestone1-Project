# terraform {
#   backend "s3" {
#     bucket = "tf-remote-bucket-milestone-1-theodoros-gkisis1"
#     key = "tf-remote-bucket-milestone-1-theodoros-gkisis/MILE1/terraform/tfstate"
#     region = "eu-central-1"
#     dynamodb_table = "tf-lock-table"
#   }
# }

provider "aws" {
  region = "eu-central-1"
}

locals {
  common_tags = {
    Environment = "Production"
    Project     = "Milestone-1"
  }
}
