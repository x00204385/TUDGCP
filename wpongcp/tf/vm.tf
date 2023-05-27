# Create Google Cloud VMs | vm.tf
# 

# Create web server #1
resource "google_compute_instance" "web_private_1" {
  name         = "webserver-vm1-${var.suffix}"
  machine_type = "e2-medium"
  zone         = var.gcp_zone_1
  tags         = ["ssh", "http", "icmp"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata_startup_script = <<-EOF
    sudo apt update -y 
    sudo apt install -y apache2 
    sudo apt install -y php libapache2-mod-php php-mysql
    sudo apt install -y mysql-server
    cd /tmp
    sudo curl -O https://wordpress.org/latest.tar.gz
    sudo tar xf latest.tar.gz
    sudo mv wordpress/ /var/www/html/
    sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    cd /var/www/html/wordpress
    sudo sed -i 's/database_name_here/wp/g' wp-config.php
    sudo sed -i 's/username_here/wp_user/g' wp-config.php
    sudo sed -i 's/password_here/Computing1/g' wp-config.php
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/
    sudo touch /tmp/startup_done
  EOF

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
  }
}

# Create web server #2
resource "google_compute_instance" "web_private_2" {
  name         = "webserver-vm2-${var.suffix}"
  machine_type = "e2-medium"
  zone         = var.gcp_zone_1
  tags         = ["ssh", "http", "icmp"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }


  metadata_startup_script = <<-EOF
    sudo apt update -y 
    sudo apt install -y apache2 
    sudo apt install -y php libapache2-mod-php php-mysql
    sudo apt install -y mysql-server
    cd /tmp
    sudo curl -O https://wordpress.org/latest.tar.gz
    sudo tar xf latest.tar.gz
    sudo mv wordpress/ /var/www/html/
    sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    cd /var/www/html/wordpress
    sudo sed -i 's/database_name_here/wp/g' wp-config.php
    sudo sed -i 's/username_here/wp_user/g' wp-config.php
    sudo sed -i 's/password_here/Computing1/g' wp-config.php
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/
    sudo touch /tmp/startup_done
  EOF

# metadata_startup_script = "${file("../provision-wordpress.sh")}"


  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
  }
}


resource "google_compute_instance" "apps" {
  count        = 2
  name         = "webserver-pub-${var.suffix}-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = var.gcp_zone_1
  tags         = ["ssh", "http", "icmp"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  depends_on = [google_filestore_instance.wordpress]

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name

    access_config {
      // Ephemeral IP
    }
  }
# Pass the startup script as metadata. Use Terraform interpolation to fill in some parameters
metadata = {
  provision_script = templatefile("${path.module}/../scripts/provision-wordpress.sh", {
      mount_point = google_filestore_instance.wordpress.networks.0.ip_addresses.0
    })}

# Startup script to provision wordpress
# To rerun: sudo google_metadata_script_runner startup
# To see the output: sudo journalctl -u google-startup-scripts.servic
metadata_startup_script = <<-EOF
  # Retrieve provision-wordpress.sh from metadata server and execute it
  curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/provision_script" > /tmp/provision-wordpress.sh
  chmod +x /tmp/provision-wordpress.sh
  /tmp/provision-wordpress.sh
EOF

}