# 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#

# Load the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = var.profile

  default_tags {
    tags = {
      environment = "sandbox"
      name        = "cka-training-cluster"
    }
  }
}
