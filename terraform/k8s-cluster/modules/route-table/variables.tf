variable "route_table_should_be_created" {
  description = "Should the Route Table be created?"
  type        = bool
  default     = true
}

variable "route_table_name" {
  description = "Route Table name"
  type        = string
  default     = "k8s Route Table"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}
