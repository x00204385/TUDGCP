
output "mysql-internal-ip" {
  description = "The private IP address of the MySQL database"
  value       = google_compute_instance.mysql.network_interface.0.network_ip
}


output "wpdb_instance_name" {
  description = "The name of the wp Cloud SQL database instance"
  value       = google_sql_database_instance.wordpress.name
}


# show external ip address of load balancer
output "load-balancer-ip-address" {
  description = "TThe public IP address of the load balancer"
  value       = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}

# Mount point for filestore
output "nfs_mount_point" {
  description = "The IP address of the filestore mount point"
  value       = google_filestore_instance.wordpress.networks.0.ip_addresses.0
}
