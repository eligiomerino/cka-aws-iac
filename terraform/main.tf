/* By Eligio Merino, 2024
   https://github.com/eligiomerino
*/
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
# Change the path whereever you have stored your local AWS configuration
provider "aws" {
  shared_credentials_files = ["../.aws/credentials"]
  shared_config_files      = ["../.aws/config"]

  default_tags {
    tags = {
      terraform   = "true"
      environment = "sandbox"
      project     = "cka-training-cluster"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "public_subnet" {
  source = "./modules/public-subnet"

  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "./modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "./modules/route-table"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_id    = module.public_subnet.public_subnet_id
}

module "ec2" {
  source = "./modules/ec2"

  # 2vCPUs, 2GB RAM
  control_plane_shape = "t4g.small"
  control_plane_count = 1

  # 2vCPUs, 4GB RAM
  worker_node_shape = "t4g.medium"
  worker_node_count = 2

  control_plane_name = "k8s-control-plane"
  worker_node_name   = "k8s-worker-node"

  vpc_id           = module.vpc.vpc_id
  vpc_cidr_block   = module.vpc.vpc_cidr_block
  public_subnet_id = module.public_subnet.public_subnet_id

  # Make sure you already generated an SSH in the specified path using this command:
  # ssh-keygen -f ec2-key -t rsa -b 4096 -C "you@example.com" -o
  ec2_ssh_key_name        = var.ec2_ssh_key_name
  ec2_ssh_public_key_path = var.ec2_ssh_public_key_path
}
