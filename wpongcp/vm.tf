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
    sudo apt install -y nfs-common
    sudo apt install -y mysql-server
    sudo mkdir /var/www/html/wordpress
    echo "'sudo sudo mount -o rw,intr,hard,timeo=600,retrans=3,rsize=262144,wsize=1048576,resvport 172.26.61.250:/wordpress  /mnt/fs' >> mount.sh
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


resource "google_compute_instance" "apps" {
  count        = 2
  name         = "webserver-pub-${count.index + 1}"
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

# Startup script to provision wordpress
# To rerun: sudo journalctl -u google-startup-scripts.serviceta_script_runner startup
# To see the output: sudo journalctl -u google-startup-scripts.service
#
  metadata_startup_script = <<-EOF
    sudo apt update -y 
    sudo apt install -y nfs-common
    sudo mkdir /var/www/html/wordpress
    echo 'sudo mount -o rw,intr,hard,timeo=600,retrans=3,rsize=262144,wsize=1048576,resvport ${google_filestore_instance.wordpress.networks.0.ip_addresses.0}:/wordpress /var/www/html/wordpress' >> /tmp/mount.sh
    sudo mount -o rw,intr,hard,timeo=600,retrans=3,rsize=262144,wsize=1048576,resvport ${google_filestore_instance.wordpress.networks.0.ip_addresses.0}:/wordpress /var/www/html/wordpress
    sudo apt install -y mysql-client
    sudo apt install -y php libapache2-mod-php php-mysql
    sudo apt install -y apache2 
    cd /tmp
    sudo curl -O https://wordpress.org/latest.tar.gz
    sudo tar xf latest.tar.gz -C /var/www/html
    sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
    cd /var/www/html/wordpress
    sudo sed -i 's/database_name_here/wp/g' wp-config.php
    sudo sed -i 's/username_here/wp_user/g' wp-config.php
    sudo sed -i 's/password_here/Computing1/g' wp-config.php
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/
    sudo touch /tmp/startup_done
  EOF
}