# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 4
}

# Create VM #1
resource "google_compute_instance" "vm_instance_public" {
  project      = var.project_id
  name         = "web-server"
  machine_type = "e2-medium"
  zone         = var.gcp_zone_1
  tags         = ["ssh", "http"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata_startup_script = <<-EOF
    sudo apt update
    sudo apt install -yq build-essential apache2
    sudo apt install -y mysql-server
    sudo apt install -y net-tools
    sudo touch /tmp/startup_done
  EOF

  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public_subnet_1.name

    access_config {}
  }
}
