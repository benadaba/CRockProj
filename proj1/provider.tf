# 01. declare terraform and provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# 02. Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

