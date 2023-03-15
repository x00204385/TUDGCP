provider "google" {
}

resource "google_compute_instance" "webapp" {
  project      = var.project_id
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    subnetwork = var.subnetwork
    access_config {
      // Left blank to assign public IP
    }
  }

  metadata = {
    ssh-keys = "${var.username}:${file("~/.ssh/google_compute_engine.pub")}"
  }

  metadata_startup_script = "sudo apt update && sudo apt -y install apache2"

  tags = ["http-server", "https-server", "default-allow-http", "default-allow-https", "ssh", "http"]

  service_account {
    email = var.client_email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}
