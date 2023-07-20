primary = true
# GCP Settings
gcp_region_1  = "europe-west1"
gcp_zone_1    = "europe-west1-b"
gcp_auth_file = ""
app_name      = "wordpress"
gke_location = "europe-west1-b"
# GCP Netwok
private_subnet_cidr_1 = "10.10.1.0/24"
private_subnet_cidr_2 = "10.10.2.0/24"
public_subnet_cidr_1  = "10.10.3.0/24"
public_subnet_cidr_2  = "10.10.4.0/24"
#
# Autoscaling
#
lb_max_replicas = 6
lb_min_replicas = 2
lb_cooldown_period = 300

suffix = "eu"

