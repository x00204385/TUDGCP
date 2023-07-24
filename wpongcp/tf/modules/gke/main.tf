# Based on https://www.youtube.com/watch?v=X_IK0GBbBTw and 
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/main/gke.tf
# 

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
  display_name = "GKE Service Account"
}


# GKE cluster
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
#
resource "google_container_cluster" "gkecluster" {
  name = "iac-gke-${var.suffix}"
  # location = var.region
  # location = var.gke_cluster_location
  location = var.gke_location

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

   private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    # master_ipv4_cidr_block  = "172.16.0.0/28"
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block

  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.gke_subnet

}

# Separately Managed Node Pool
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool.html
#
resource "google_container_node_pool" "gkecluster_nodes" {
  name = google_container_cluster.gkecluster.name
  # location   = var.region
  # location   = var.gke_cluster_location
  location = var.gke_location
  cluster  = google_container_cluster.gkecluster.name
  node_count = 2
    max_pods_per_node = 64



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

    # oauth_scopes = [
    #   "https://www.googleapis.com/auth/logging.write",
    #   "https://www.googleapis.com/auth/monitoring",
    # ]

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
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

  depends_on = [google_container_cluster.gkecluster]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      echo 'Updating kubeconfig with cluster credentials...'
      gcloud container clusters get-credentials ${google_container_cluster.gkecluster.name} --zone ${var.gke_location}
    EOT
  }
}

