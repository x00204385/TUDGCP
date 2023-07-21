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

