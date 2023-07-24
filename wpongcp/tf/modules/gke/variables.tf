variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string
  default     = null
}

variable "network" {
  description = "The network to which we deploy the resources"
  type = string
  default = null
}


variable "gke_subnet" {
  description = "Subnet where GKE cluster and MIG will deploy"
  type        = string
  default     = null
}

variable "gke_location" {
  description = "The GCP zone to deploy GKE control plane and nodes"
  type        = string
  default     = null
}

variable "suffix" {
  description = "Suffix used to distinguish primary and secondary resources"
  type        = string
  default     = null
}

variable "cluster_secondary_range_name" {
  description = "CIDR used for pod IPs in GKE cluster"
  type        = string
  default     = null
}

variable "services_secondary_range_name" {
  description = "CIDR used for service IPs in GKE cluster"
  type        = string
  default     = null
}

variable "master_ipv4_cidr_block" {
  description = "CIDR to use for control plane in GKE cluster"
  type        = string
  default     = null
}