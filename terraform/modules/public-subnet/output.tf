output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = concat(aws_subnet.public_subnet.*.id, [""])[0]
}

output "public_subnet_arn" {
  description = "Public Subnet ARN"
  value       = concat(aws_subnet.public_subnet.*.arn, [""])[0]
}
