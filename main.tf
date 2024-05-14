provider "aws" {
  region = "eu-central-1"
}


locals {
  common_tags = {
    Environment = "Production"
    Project     = "Milestone-1"
  }
}
