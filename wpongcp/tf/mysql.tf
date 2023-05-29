#    sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
#     sudo sed -i "s|bind-address.*|#bind-address|" /etc/mysql/mysql.conf.d/mysqld.cnf

#
# This file creates a compute engine instance and deploys MySQL on it. This is just for convenience as creating a CloudSQL instance
# in GCP with Terraform can take 20 minutes. This creates in a few minutes and can allow us to run Wordpress
#

resource "google_compute_instance" "mysql" {
  name         = "mysql-instance-${var.suffix}"
  machine_type = "e2-micro"
  zone         = var.gcp_zone_1

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }


  network_interface {
    network    = data.google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private_subnet_1.name
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

  tags = ["ssh", "http", "mysql", "icmp"]
}
