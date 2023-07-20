#
# Define providers. Google has two provider APis. The default and a beta provider for API that are still in beta
#

provider "google" {
  project = var.project_id
  region  = var.gcp_region_1
  zone    = var.gcp_zone_1
}

provider "google-beta" {
  project = var.project_id
  region  = var.gcp_region_1
  zone    = var.gcp_zone_1
}
