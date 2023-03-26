# Create Google Cloud VMs | vm.tf

# Create web server #1
resource "google_compute_instance" "web_private_1" {
  name         = "webserver-vm1"
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
  name         = "webserver-vm2"
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