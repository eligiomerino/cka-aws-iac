variable "subnet_should_be_created" {
  description = "Should the Public Subnet be created?"
  type        = bool
  default     = true
}

variable "subnet_name" {
  description = "Public Subnet name"
  type        = string
  default     = "k8s Public Subnet"
}

variable "subnet_cidr_block" {
  description = "Public Subnet IPv4 CIDR block"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_availability_zone" {
  description = "Public Subnet AZ"
  type        = string
  default     = "us-west-1a"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
