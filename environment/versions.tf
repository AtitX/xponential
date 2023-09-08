# Terraform Block
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

  }

  backend "s3" {
  }

}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = var.profile
  default_tags {
    tags = {
      Environment = var.environment
      Owner       = var.owner
    }
  }
}

