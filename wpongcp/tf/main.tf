locals {
  public_subnets = [google_compute_subnetwork.public_subnet_1.name, google_compute_subnetwork.public_subnet_2.name]
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