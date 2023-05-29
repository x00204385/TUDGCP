# Create a Cloud SQL instance and enable access to it from the VM instances
# created. 
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
# https://cloud.google.com/sql/docs/mysql/authorize-networks

# create Cloud SQL instance
resource "google_sql_database_instance" "wordpress" {
  name             = "wordpress-instance-${var.suffix}"
  region           = var.gcp_region_1
  database_version = "MYSQL_5_7"
  provider         = google-beta

  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    disk_size         = 10
    disk_autoresize   = false
    disk_type         = "PD_HDD"
    availability_type = "ZONAL"

    backup_configuration {
      enabled = false
    }

    ip_configuration {

      ipv4_enabled = false

      enable_private_path_for_google_cloud_services = true

      private_network = data.google_compute_network.vpc.id

      # # Home network connection (debugging)
      # authorized_networks {
      #   name = "home laptop"
      #   value = "1.2.3.4/32"
      # }

    }
  }
}

# Create MySQL user
resource "google_sql_user" "wordpress_user" {
  name     = "wp_user"
  instance = google_sql_database_instance.wordpress.name
  host     = "%"
  password = "Computing1"
}

# # create MySQL database
resource "google_sql_database" "wp" {
  name     = "wp"
  instance = google_sql_database_instance.wordpress.name
}

