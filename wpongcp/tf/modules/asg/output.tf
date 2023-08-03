# show external ip address of load balancer
output "load_balancer_ip_address" {
  description = "The public IP address of the load balancer"
  value       = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}
