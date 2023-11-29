provider "aws" {
  region = "ap-south-1"
  assume_role {
    role_arn = "arn:aws:iam::714558904912:role/tfelabuser"
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