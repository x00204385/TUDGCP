# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance
#
resource "google_filestore_instance" "wordpress" {
  name    = "wordpress"
  project = var.project_id

  location = var.gcp_zone_1
  tier     = "BASIC_HDD"

  networks {
    network = google_compute_network.vpc.name
    modes   = ["MODE_IPV4"]
  }

  file_shares {
    capacity_gb = 1024
    name        = "wordpress"
  }
}

output "nfs_mount_point" {
   value = google_filestore_instance.wordpress.networks.0.ip_addresses.0
 }

