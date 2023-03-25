
# create VPC
resource "google_compute_network" "vpc" {
  name                    = "wordpress-vpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
}



# create public subnet
resource "google_compute_subnetwork" "public_subnet_1" {
  name          = "wordpress-public-subnet-1"
  ip_cidr_range = var.public_subnet_cidr_1
  network       = google_compute_network.vpc.name
  region        = var.gcp_region_1
}


