output "route_table_id" {
  description = "Route Table ID"
  value       = concat(aws_route_table.route_table.*.id, [""])[0]
}
