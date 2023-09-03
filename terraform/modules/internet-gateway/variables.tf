variable "internet_gateway_should_be_created" {
  description = "Should the Internet Gateway be created?"
  type        = bool
  default     = true
}

variable "internet_gateway_name" {
  description = "Internet Gateway name"
  type        = string
  default     = "k8s Internet Gateway"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
