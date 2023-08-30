/*
output "k8s_cluster_ips" {
  value = ["${module.ec2.control_plane_ip}", "${module.ec2.worker_node_ip}"]
}
*/

output "control_plane_ip" {
  value = ["${module.ec2.control_plane_ip}"]
}

output "worker_node_ip" {
  value = ["${module.ec2.worker_node_ip}"]
}
