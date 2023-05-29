# Load balancer with managed instance group 
# used to forward traffic to the correct load balancer for HTTP load balancing
# 
# 
#
#         +-------------------+
#         |  Forwarding Rule  |
#         +-------------------+
#                     |
#                     V
#         +-------------------+
#         | Target HTTP Proxy |
#         +-------------------+
#                     |
#                     V
#         +-------------------+
#         |      URL Map      |
#         +-------------------+
#                     |
#                     V
#         +-------------------+
#         |  Backend Service  |
#         +-------------------+
#                     |
#                     V
# +----------------------------+
# | Compute Instance Group Mgr |
# +----------------------------+
#                     |
#                     V
# +-------------------------+
# |  Managed Instance Group |
# +-------------------------+

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "wordpress-global-forwarding-rule-${var.suffix}"
  project    = var.project_id
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}

# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "wordpress-proxy-${var.suffix}"
  project = var.project_id
  url_map = google_compute_url_map.url_map.self_link
}

# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  name          = "wordpress-backend-service-${var.suffix}"
  project       = var.project_id
  port_name     = "http"
  protocol      = "HTTP"
  health_checks = ["${google_compute_health_check.healthcheck.self_link}"]

  backend {
    group                 = google_compute_instance_group_manager.web_private_group.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}



# creates a group of virtual machine instances
resource "google_compute_instance_group_manager" "web_private_group" { # Change the name of the group manager (or make it private)
  name        = "wordpress-vm-group-${var.suffix}"
  description = "Wordpress app servers instance group"
  project     = var.project_id
  zone        = var.gcp_zone_1

  base_instance_name = "wordpress-web-${var.suffix}"

  depends_on = [google_filestore_instance.wordpress, google_sql_database_instance.wordpress]

  version {
    instance_template = google_compute_instance_template.web_server.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
}

# determine whether instances are responsive and able to do work
resource "google_compute_health_check" "healthcheck" {
  name = "wordpress-healthcheck--${var.suffix}"

  timeout_sec        = 1
  check_interval_sec = 1
  http_health_check {
    port = 80
  }
}

# used to route requests to a backend service based on rules that you define for the host and path of an incoming URL
resource "google_compute_url_map" "url_map" {
  name            = "wordpress-load-balancer-${var.suffix}"
  project         = var.project_id
  default_service = google_compute_backend_service.backend_service.self_link
}


# automatically scale virtual machine instances in managed instance groups according to an autoscaling policy
resource "google_compute_autoscaler" "autoscaler" {
  name    = "wordpress-load-balancer-${var.suffix}-autoscaler"
  project = var.project_id
  zone    = var.gcp_zone_1
  target  = google_compute_instance_group_manager.web_private_group.self_link

  autoscaling_policy {
    max_replicas    = var.lb_max_replicas
    min_replicas    = var.lb_min_replicas
    cooldown_period = var.lb_cooldown_period

    cpu_utilization {
      target = 0.8
    }
  }
}





