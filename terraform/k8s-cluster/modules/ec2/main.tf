data "external" "get_my_public_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

resource "aws_security_group" "control_plane_sg" {
  name        = "k8s-control-plane-sg"
  description = "K8s Control Plane Firewall"

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = var.vpc_id

  # Control Plane inbound traffic
  dynamic "ingress" {
    for_each = var.control_plane_ports
    iterator = port
    content {
      description = port.key
      from_port   = lookup(var.control_plane_ports, port.key)
      to_port     = lookup(var.control_plane_ports, port.key)
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr_block]
    }
  }

  ingress {
    description = "Client API (etcd server)"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    description = "Public Inbound Traffic for my IP only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [format("%s/%s", data.external.get_my_public_ip.result.ip, "32")]
  }

  # Control Plane outbound traffic
  egress {
    description = "Public Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ec2_public_internet]
  }

  tags = {
    Name = "k8s-control-plane-sg"
  }
}

resource "aws_security_group" "worker_node_sg" {
  name        = "k8s-worker-node-sg"
  description = "K9s Worker Node Firewall"

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = var.vpc_id

  # Worker Node inbound traffic
  dynamic "ingress" {
    for_each = var.worker_node_ports
    iterator = port
    content {
      description = port.key
      from_port   = lookup(var.worker_node_ports, port.key)
      to_port     = lookup(var.worker_node_ports, port.key)
      protocol    = "tcp"
      cidr_blocks = [var.vpc_cidr_block]
    }
  }

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    description = "Public Inbound Traffic for my IP only"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [format("%s/%s", data.external.get_my_public_ip.result.ip, "32")]
  }

  # Control Plane outbound traffic
  egress {
    description = "Public Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ec2_public_internet]
  }

  tags = {
    Name = "k8s-worker-node-sg"
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.ec2_ssh_key_name
  public_key = file(var.ec2_ssh_public_key_path)
}

data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "manifest-location"
    values = ["amazon/ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "platform-details"
    values = ["Linux/UNIX"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "is-public"
    values = ["true"]
  }
}

resource "aws_instance" "control_plane" {
  ami           = data.aws_ami.ubuntu_server.id
  count         = var.control_plane_count
  instance_type = var.control_plane_shape

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.control_plane_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.ec2_key_pair.key_name

  user_data = file("../scripts/cloudinit-k8s-common-components.yaml")

  tags = {
    Name = var.control_plane_name
  }
}

resource "aws_instance" "worker_nodes" {
  ami           = data.aws_ami.ubuntu_server.id
  count         = var.worker_node_count
  instance_type = var.worker_node_shape

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.worker_node_sg.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.ec2_key_pair.key_name

  user_data = file("../scripts/cloudinit-k8s-common-components.yaml")

  tags = {
    Name = var.worker_node_name
  }
}
