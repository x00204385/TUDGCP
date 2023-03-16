#    sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf

resource "google_compute_instance" "mysql" {
  name         = "mysql-instance"
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
    sudo apt update
    sudo apt install -y mysql-server
    sudo apt install -y net-tools
    sudo service mysql restart
    sudo mysql -e "CREATE DATABASE wp;"
    sudo mysql -e "CREATE USER 'wp_user'@'%' IDENTIFIED BY 'Computing1';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON wp.* TO 'wp_user'@'%' WITH GRANT OPTION;"
  EOF

  tags = ["http-server", "https-server", "ssh", "http"]


}
