#    sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
#     sudo sed -i "s|bind-address.*|#bind-address|" /etc/mysql/mysql.conf.d/mysqld.cnf

resource "google_compute_instance" "mysql" {
  project      = var.project_id
  name         = "mysql-instance"
  machine_type = "e2-micro"
  zone         = var.gcp_zone_1
  tags         = ["ssh", "http", "https", "mysql"]


  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name

    access_config {
      // Allocate a public IP address to the instance.
    }
  }

  metadata_startup_script = <<-EOF
    sudo apt update
    sudo apt install -y mysql-server
    sudo apt install -y net-tools
    sudo sed -i "s/^bind-address/#bind-address/g" /etc/mysql/mysql.conf.d/mysqld.cnf
    sudo service mysql restart
    sudo mysql -e "CREATE DATABASE wp;"
    sudo mysql -e "CREATE USER 'wp_user'@'%' IDENTIFIED BY 'Computing1';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON wp.* TO 'wp_user'@'%' WITH GRANT OPTION;"
    sudo touch /tmp/startup_done
  EOF



}
