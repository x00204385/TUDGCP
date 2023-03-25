resource "google_compute_instance" "wordpress" {
  name         = "wordpress-instance"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Allocate a public IP address to the instance.
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
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/
    sudo touch /tmp/startup_done
  EOF

  tags = ["http-server", "https-server", "ssh", "http"]


}
