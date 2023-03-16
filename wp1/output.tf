output "ip" {
  value = google_compute_instance.webapp.network_interface.0.access_config.0.nat_ip
}

output "wp_ip" {
  value = google_compute_instance.wordpress.network_interface.0.access_config.0.nat_ip
}

output "mysql_ip" {
  value = google_compute_instance.mysql.network_interface.0.access_config.0.nat_ip
}



