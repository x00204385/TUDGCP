locals {
  public_subnets  = [google_compute_subnetwork.public_subnet_1.name, google_compute_subnetwork.public_subnet_2.name]
  private_subnets = [google_compute_subnetwork.private_subnet_1.name, google_compute_subnetwork.private_subnet_2.name]

}


module "asg" {
  source = "./modules/asg"

  project_id = var.project_id

  suffix = var.suffix
  gcp_zone_1 = var.gcp_zone_1
  asg_subnets = local.private_subnets
  network = data.google_compute_network.vpc.name

  mount_point = google_filestore_instance.wordpress.networks.0.ip_addresses.0
  db_ip_address = google_compute_instance.mysql.network_interface.0.network_ip


  depends_on = [google_filestore_instance.wordpress, google_sql_database_instance.wordpress]

}

module "gke" {
  source = "./modules/gke"

  project_id = var.project_id
  network    = data.google_compute_network.vpc.name

  gke_subnet = google_compute_subnetwork.private_subnet_1.name

  cluster_secondary_range_name  = "k8s-pod-range-${var.suffix}"
  services_secondary_range_name = "k8s-service-range-${var.suffix}"
  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
  gke_location                  = var.gke_location
  suffix                        = var.suffix

}

resource "null_resource" "update_configmap" {
  triggers = {
    always = timestamp()
  }

  depends_on = [module.gke]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      set -e
      echo 'Updating configmap with private IP of Cloud SQL instance ...'
      kubectl get configmap cloudsql -n default || kubectl create configmap cloudsql --from-literal=private_ip=${google_sql_database_instance.wordpress.private_ip_address} -n default
      kubectl get configmap filestore -n default || kubectl create configmap filestore --from-literal=private_ip=${google_filestore_instance.wordpress.networks.0.ip_addresses.0} -n default
    EOT
  }
}