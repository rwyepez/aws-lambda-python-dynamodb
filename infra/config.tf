terraform {
  backend "s3" {
    bucket = "ryrypatungo95"
    key    = "resources/terraform.state"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.11.0"
    }
  }
}