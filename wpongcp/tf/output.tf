
output "mysql-internal-ip" {
  description = "The private IP address of the MySQL database"
  value       = google_compute_instance.mysql.network_interface.0.network_ip
}


output "wpdb_instance_name" {
  description = "The name of the wp Cloud SQL database instance"
  value       = google_sql_database_instance.wordpress.name
}


# show external ip address of load balancer
output "load_balancer_ip_address" {
  description = "TThe public IP address of the load balancer"
  value       = module.asg.load_balancer_ip_address
}

# Mount point for filestore
output "nfs_mount_point" {
  description = "The IP address of the filestore mount point"
  value       = google_filestore_instance.wordpress.networks.0.ip_addresses.0
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}
