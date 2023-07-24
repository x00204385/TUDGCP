primary = false
# GCP Settings
gcp_region_1  = "us-central1"
gcp_zone_1    = "us-central1-b"
gcp_auth_file = ""
app_name      = "wordpress"
gke_location  = "us-central1-a"
# GCP Netwok
private_subnet_cidr_1 = "10.10.5.0/24"
private_subnet_cidr_2 = "10.10.6.0/24"
public_subnet_cidr_1  = "10.10.7.0/24"
public_subnet_cidr_2  = "10.10.8.0/24"
#
# GKE secondary ranges
#
master_ipv4_cidr_block  = "172.16.1.0/28"
gke_pod_ip_range      = "10.49.0.0/20"
gke_services_ip_range = "10.53.0.0/20"
#
#
# Autoscaling
#
# lb_max_replicas = 6
# lb_min_replicas = 2
# lb_cooldown_period = 300
#
# Prefix for resources.
suffix = "us"
