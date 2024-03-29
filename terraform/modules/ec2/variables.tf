variable "ec2_should_be_created" {
  description = "Should the EC2 be created?"
  type        = bool
  default     = true
}

variable "control_plane_name" {
  description = "EC2 name"
  type        = string
  default     = "k8s machine"
}

variable "worker_node_name" {
  description = "EC2 name"
  type        = string
  default     = "k8s machine"
}

variable "control_plane_ports" {
  description = "Inboud Traffic in Control Plane"
  default = {
    "Kubernetes API server"   = "6443"
    "Kubelet API"             = "10250"
    "Kube Scheduler"          = "10251"
    "Kube Controller Manager" = "10252"
  }
}

variable "worker_node_ports" {
  description = "Inboud Traffic traffic in Worker Node"
  default = {
    "Kubelet API" = "10250"
  }
}

variable "control_plane_shape" {
  description = "EC2 instance type for Control Plane"
  type        = string
  default     = "t2.micro"
}

variable "control_plane_count" {
  description = "Number of Control Plane machines"
  type        = number
  default     = 1
}

variable "worker_node_shape" {
  description = "EC2 instance type for Worker Node"
  type        = string
  default     = "t2.micro"
}

variable "worker_node_count" {
  description = "Number of Worker Node machines"
  type        = number
  default     = 2
}

variable "ec2_instance_count" {
  description = "The number of EC2 instances to be created"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}

variable "ec2_ssh_key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "ec2-key"
}

variable "ec2_ssh_public_key_path" {
  description = "Local path to the SSH Public Key"
  type        = string
}

variable "ec2_public_internet" {
  description = "CIDR Block for Public Internet"
  type        = string
  default     = "0.0.0.0/0"
}
