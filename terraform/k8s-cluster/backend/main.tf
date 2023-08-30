module "vpc" {
  source = "../modules/vpc"
}

module "public_subnet" {
  source = "../modules/public-subnet"

  vpc_id = module.vpc.vpc_id
}

module "internet_gateway" {
  source = "../modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source = "../modules/route-table"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_id    = module.public_subnet.public_subnet_id
}

module "ec2" {
  source = "../modules/ec2"

  # 2vCPUs, 2GB RAM
  control_plane_shape = "t3.small"

  # 2vCPUs, 4GB RAM
  worker_node_shape = "t3.medium"

  control_plane_name = "k8s-control-plane"
  worker_node_name   = "k8s-worker-node"

  vpc_id           = module.vpc.vpc_id
  vpc_cidr_block   = module.vpc.vpc_cidr_block
  public_subnet_id = module.public_subnet.public_subnet_id

  # Make sure you already generated an SSH in the specified path using this command:
  # ssh-keygen -f k8s-ec2-key -t rsa -b 4096 -C "you@example.com" -o
  ec2_ssh_key_name        = var.ec2_ssh_key_name
  ec2_ssh_public_key_path = var.ec2_ssh_public_key_path
}
