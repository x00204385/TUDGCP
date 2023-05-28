# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance
#
resource "google_filestore_instance" "wordpress" {
  name    = "wordpress-${var.suffix}"
  project = var.project_id

  location = var.gcp_zone_1
  tier     = "BASIC_HDD"

  networks {
    network = data.google_compute_network.vpc.name
    modes   = ["MODE_IPV4"]
  }

  file_shares {
    capacity_gb = 1024
    name        = "wordpress"
  }
}