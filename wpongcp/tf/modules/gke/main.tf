# Based on https://www.youtube.com/watch?v=X_IK0GBbBTw and 
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/main/gke.tf
# 

# GKE cluster
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
#
resource "google_container_cluster" "primary" {
  name = "iac-gke-${var.suffix}"
  # location = var.region
  # location = var.gke_cluster_location
  location = var.gke_location

  ip_allocation_policy {

  }

   private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }


  # node_locations = ["us-central1-b"]

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  remove_default_node_pool = true
  initial_node_count       = 1

  # network    = data.google_compute_network.vpc.name
  network    = var.network
  # subnetwork = google_compute_subnetwork.public_subnet_1.name
  subnetwork = var.gke_subnet

}

# Separately Managed Node Pool
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool.html
#
resource "google_container_node_pool" "primary_nodes" {
  name = google_container_cluster.primary.name
  # location   = var.region
  # location   = var.gke_cluster_location
  location = var.gke_location
  cluster  = google_container_cluster.primary.name
  node_count = 2


  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }


  node_config {
    preemptible  = true   # Use spot instances
    machine_type = "e2-medium"
    # machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    disk_size_gb = 20

    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "null_resource" "update_kubeconfig" {
  triggers = {
    always = timestamp()
  }

  depends_on = [google_container_cluster.primary]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      echo 'Updating kubeconfig with cluster credentials...'
      gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone ${var.gke_location}
    EOT
  }
}

