output "my_public_ip" {
  value = data.external.get_my_public_ip.result.ip
}

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

output "control_plane_ip" {
  description = "Control Plane IP"
  value       = ["${aws_instance.control_plane.*.public_ip}"]
}

output "worker_node_ip" {
  description = "Worker Nodes IPs"
  value       = ["${aws_instance.worker_nodes.*.public_ip}"]
}
