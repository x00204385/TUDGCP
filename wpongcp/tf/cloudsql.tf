# Create a Cloud SQL instance and enable access to it from the VM instances
# created. 
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
# https://cloud.google.com/sql/docs/mysql/authorize-networks

# create Cloud SQL instance
resource "google_sql_database_instance" "wordpress" {
  name             = "wordpress-instance"
  region           = var.gcp_region_1
  database_version = "MYSQL_5_7"

  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {

      # # Home network connection (debugging)
      # authorized_networks {
      #   name = "home laptop"
      #   value = "1.2.3.4/32"
      # }

      dynamic "authorized_networks" {
        for_each = google_compute_instance.apps
        iterator = apps

        content {
          name  = apps.value.name
          value = apps.value.network_interface.0.access_config.0.nat_ip
        }
      }
    }
    backup_configuration {
      enabled = false
    }
  }
}

# create Cloud SQL user
resource "google_sql_user" "wordpress_user" {
  name     = "wp_user"
  instance = google_sql_database_instance.wordpress.name
  host     = "%"
  password = "Computing1"
}

# create Cloud SQL database
resource "google_sql_database" "wp" {
  name     = "wp"
  instance = google_sql_database_instance.wordpress.name
}

