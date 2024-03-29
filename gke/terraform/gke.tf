# Based on https://www.youtube.com/watch?v=X_IK0GBbBTw and 
# https://github.com/hashicorp/learn-terraform-provision-gke-cluster/blob/main/gke.tf
# 

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

# GKE cluster
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
#
resource "google_container_cluster" "primary" {
  name = "${var.project_id}-gke"
  # location = var.region
  # location = var.gke_cluster_location
  location = "us-central1-a"


  # node_locations = ["us-central1-b"]

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

}

# Separately Managed Node Pool
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool.html
#
resource "google_container_node_pool" "primary_nodes" {
  name = google_container_cluster.primary.name
  # location   = var.region
  # location   = var.gke_cluster_location
  location = "us-central1-a"
  cluster  = google_container_cluster.primary.name
  # node_count = 4


  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }

  node_config {
    preemptible  = true
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


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

