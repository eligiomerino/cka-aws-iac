#
# You can parse values from the JSON output by using these commands:
# terraform output -json control_plane_data | jq -r '.[] .public_ip'
# terraform output -json worker_node_data | jq -r '.[] .public_ip'
#

output "control_plane_data" {
  value = module.ec2.control_plane_ip
}

output "worker_node_data" {
  value = module.ec2.worker_node_ip
}
