# Virtual machine output | vm-output.tf
# output "web-1-name" {
#   value = google_compute_instance.web_private_1.name
# }
# output "web-1-internal-ip" {
#   value = google_compute_instance.web_private_1.network_interface.0.network_ip
# }
# output "web-2-name" {
#   value = google_compute_instance.web_private_2.name
# }
# output "web-2-internal-ip" {
#   value = google_compute_instance.web_private_2.network_interface.0.network_ip
# }

output "mysql-internal-ip" {
  value = google_compute_instance.mysql.network_interface.0.network_ip
}


# output "instance_public_instances" {
#   value = { for instance in google_compute_instance.apps : instance.name => instance.network_interface[0].access_config[0].nat_ip }
# }


# output "wpdb_instance_name" {
#   description = "The name of the wp Cloud SQL database instance"
#   value       = google_sql_database_instance.wordpress.name
# }

# output "wpdb_public_ip_address" {
#   description = "The public IPv4 address of the wp CloudSQL instance."
#   value       = google_sql_database_instance.wordpress.public_ip_address
# }

# show external ip address of load balancer
output "load-balancer-ip-address" {
  value = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}

# Mount point for filestore
output "nfs_mount_point" {
  value = google_filestore_instance.wordpress.networks.0.ip_addresses.0
}
