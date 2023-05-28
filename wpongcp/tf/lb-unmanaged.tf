# # Load balancer with unmanaged instance group 
# # used to forward traffic to the correct load balancer for HTTP load balancing

# resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
#   name       = "wordpress-global-forwarding-rule-${var.suffix}"
#   project    = var.project_id
#   target     = google_compute_target_http_proxy.target_http_proxy.self_link
#   port_range = "80"
# }

# # used by one or more global forwarding rule to route incoming HTTP requests to a URL map
# resource "google_compute_target_http_proxy" "target_http_proxy" {
#   name    = "wordpress-proxy-${var.suffix}"
#   project = var.project_id
#   url_map = google_compute_url_map.url_map.self_link
# }

# # defines a group of virtual machines that will serve traffic for load balancing
# resource "google_compute_backend_service" "backend_service" {
#   name          = "wordpress-backend-service-${var.suffix}"
#   project       = var.project_id
#   port_name     = "http"
#   protocol      = "HTTP"
#   health_checks = ["${google_compute_health_check.healthcheck.self_link}"]

#   backend {
#     group                 = google_compute_instance_group.web_public_group.self_link
#     balancing_mode        = "RATE"
#     max_rate_per_instance = 100
#   }
# }

# # creates a group of dissimilar virtual machine instances
# resource "google_compute_instance_group" "web_public_group" {
#   name        = "wordpress-vm-group-${var.suffix}"
#   description = "Wordpress app servers instance group"
#   project     = var.project_id
#   zone        = var.gcp_zone_1
#   instances = [
#     for app_instance in google_compute_instance.apps :
#   app_instance.self_link]

#   named_port {
#     name = "http"
#     port = "80"
#   }
# }


# # determine whether instances are responsive and able to do work
# resource "google_compute_health_check" "healthcheck" {
#   name = "wordpress-healthcheck--${var.suffix}"

#   timeout_sec        = 1
#   check_interval_sec = 1
#   http_health_check {
#     port = 80
#   }
# }

# # used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
# resource "google_compute_url_map" "url_map" {
#   name            = "wordpress-load-balancer-${var.suffix}"
#   project         = var.project_id
#   default_service = google_compute_backend_service.backend_service.self_link
# }
