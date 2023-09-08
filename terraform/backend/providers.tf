# 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
#

# Load the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
  }
  required_version = "~> 1.5"
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_files = ["../../.aws/credentials"]
  shared_config_files      = ["../../.aws/config"]

  default_tags {
    tags = {
      terraform   = "true"
      environment = "sandbox"
      project     = "cka-training-cluster"
    }
  }
}
