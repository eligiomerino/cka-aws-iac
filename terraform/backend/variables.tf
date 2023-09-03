variable "profile" {
  description = "AWS Profile For Terraform"
  type        = string
  default     = "terraform"
}

variable "ec2_ssh_key_name" {
  description = "SSH Key Name"
  type        = string
  default     = "k8s-ec2-key"
}

variable "ec2_ssh_public_key_path" {
  description = "Local path to the SSH Public Key"
  type        = string
  default     = "../../.ssh/k8s-ec2-key.pub"
  sensitive   = true
}
