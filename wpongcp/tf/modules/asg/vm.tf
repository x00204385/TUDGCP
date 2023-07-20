# Create Google Cloud VMs | vm.tf
# # 
# locals {
#   public_subnets = [google_compute_subnetwork.public_subnet_1.name, google_compute_subnetwork.public_subnet_2.name]
#   private_subnets = [google_compute_subnetwork.private_subnet_1.name, google_compute_subnetwork.private_subnet_2.name]

# }

# Create template for VM instances
resource "google_compute_instance_template" "web_server" {
  name                 = "web-server-template-${var.suffix}" # Note we probably don't need one of these per region
  description          = "This template is used to create server instances. Instances running Apache + whatever is provisioned by script"
  instance_description = "Web server running apache + provisioned applications"
  can_ip_forward       = false
  machine_type         = "e2-micro"
  tags                 = ["ssh", "http"]

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }


  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    # network    = data.google_compute_network.vpc.name
    network    = var.network
    subnetwork = var.asg_subnets[0]

    access_config {
      // Ephemeral IP
    }
  }

  # Pass the startup script as metadata. Use Terraform interpolation to fill in some parameters
  metadata = {
    provision_script = templatefile("${path.module}/../../../scripts/provision-wordpress.sh", {
      mount_point = var.mount_point
      db_ip_address = var.db_ip_address
    })
  }


  # Startup script to provision wordpress
  # To rerun: sudo google_metadata_script_runner startup
  # To see the output: sudo journalctl -u google-startup-scripts.servic
  metadata_startup_script = <<-EOF
  # Retrieve provision-wordpress.sh from metadata server and execute it
  curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/provision_script" > /tmp/provision-wordpress.sh
  chmod +x /tmp/provision-wordpress.sh
  /tmp/provision-wordpress.sh
EOF


  lifecycle {
    create_before_destroy = true
  }

  # metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential apache2"
}

