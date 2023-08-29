output "ec2_id" {
  description = "Control Plane instance ID"
  value       = concat(aws_instance.control_plane.*.id, [""])[0]
}

output "ec2_arn" {
  description = "Control Plane instance ARN"
  value       = concat(aws_instance.control_plane.*.arn, [""])[0]
}

output "ec2_ami_id" {
  description = "EC2 AMI Name"
  value       = data.aws_ami.ubuntu_server.name
}
