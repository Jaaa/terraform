provider "aws" {
  region = "ap-south-1"
  assume_role {
    role_arn = "arn:aws:iam::********************"
  }
}

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
