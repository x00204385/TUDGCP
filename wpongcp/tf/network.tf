#
# Create the VPC and the subnets within. 
# As we are using the fact that GCP VPCs are global resources, we rely on the VPC having been created
# and use a terraform "data" declaration to access the VPC.

# # create VPC - no longer in use
# resource "data.google_compute_network" "vpc" {
#   name                    = "wordpress-vpc-${var.suffix}"
#   auto_create_subnetworks = "false"
#   routing_mode            = "GLOBAL"
# }


# get VPC using a data source. [TODO: Implement conditional creation of the VPC if it doesn't exist]
#
data "google_compute_network" "vpc" {
  name    = "wordpress-vpc"
  project = var.project_id
}


# create private subnet
resource "google_compute_subnetwork" "private_subnet_1" {
  provider      = google-beta
  region        = var.gcp_region_1
  purpose       = "PRIVATE"
  name          = "wordpress-private-subnet-${var.suffix}-1"
  ip_cidr_range = var.private_subnet_cidr_1
  network       = data.google_compute_network.vpc.name

  secondary_ip_range {
    range_name    = "k8s-pod-range-${var.suffix}"
    ip_cidr_range = var.gke_pod_ip_range
  }

  secondary_ip_range {
    range_name    = "k8s-service-range-${var.suffix}"
    ip_cidr_range = var.gke_services_ip_range
  }
}


# create private subnet
resource "google_compute_subnetwork" "private_subnet_2" {
  provider      = google-beta
  region        = var.gcp_region_1
  purpose       = "PRIVATE"
  name          = "wordpress-private-subnet-${var.suffix}-2"
  ip_cidr_range = var.private_subnet_cidr_2
  network       = data.google_compute_network.vpc.name
}

# create public subnet
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "wordpress-public-subnet-${var.suffix}-1"
  ip_cidr_range = var.public_subnet_cidr_1
  network       = data.google_compute_network.vpc.name
  region        = var.gcp_region_1
}

# create public subnet
resource "google_compute_subnetwork" "public_subnet_2" {
  name          = "wordpress-public-subnet-${var.suffix}-2"
  ip_cidr_range = var.public_subnet_cidr_2
  network       = data.google_compute_network.vpc.name
  region        = var.gcp_region_1
}

# create a public ip for nat service
resource "google_compute_address" "nat-ip" {
  name    = "wordpress-nat-ip"
  project = var.project_id
  region  = var.gcp_region_1
}

# create a nat to allow private instances connect to internet
resource "google_compute_router" "nat-router" {
  name    = "wordpress-nat-router"
  region  = var.gcp_region_1
  network = data.google_compute_network.vpc.name
}


resource "google_compute_router_nat" "nat-gateway" {
  name                               = "wordpress-nat-gateway"
  router                             = google_compute_router.nat-router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.nat-ip.self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_address.nat-ip]
}

output "nat_ip_address" {
  value = google_compute_address.nat-ip.address
}
