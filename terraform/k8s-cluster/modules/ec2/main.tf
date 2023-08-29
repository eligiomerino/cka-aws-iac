resource "aws_security_group" "ec2_security_group" {
  name        = var.ec2_security_group_name
  description = var.ec2_security_group_description

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = var.vpc_id

  # Control Plane inbound traffic
  dynamic "ingress" {
    for_each = var.ec2_security_group_ingress_ports
    iterator = port
    content {
      description = port.key
      from_port   = lookup(var.ec2_security_group_ingress_ports, port.key)
      to_port     = lookup(var.ec2_security_group_ingress_ports, port.key)
      protocol    = "tcp"
      cidr_blocks = [var.ec2_public_internet]
    }
  }

  ingress {
    description = "Client API (etcd server)"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.ec2_public_internet]
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
    Name = var.ec2_security_group_name
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
  count         = 1
  instance_type = var.control_plane_shape

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = var.control_plane_name
  }
}

resource "aws_instance" "worker_nodes" {
  ami           = data.aws_ami.ubuntu_server.id
  count         = 2
  instance_type = var.worker_node_shape

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.ec2_security_group.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = var.worker_node_name
  }
}
