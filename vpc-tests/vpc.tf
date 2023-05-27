# # create VPC
# resource "google_compute_network" "vpc" {
#   name                    = "wordpress-vpc"
#   auto_create_subnetworks = "false"
#   routing_mode            = "GLOBAL"
# }

# get VPC
data "google_compute_network" "vpc" {
  name                    = "wordpress-vpc"
  project                 = var.project_id
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
  name          = "wordpress-public-${var.suffix}-subnet-2"
  ip_cidr_range = var.public_subnet_cidr_2
  network       = data.google_compute_network.vpc.name
  region        = var.gcp_region_1
}
