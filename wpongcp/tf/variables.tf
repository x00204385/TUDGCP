
variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string
  default     = "tudproj-380715"
}

variable "primary" {
  type        = bool
  description = "Determine whether this is the primary or standby region"
}

variable "vpc_id" {
  type    = string
  default = null # optional with no default value
}

variable "app_name" {
  description = "App name used to name various resources"
  type        = string
  default     = "wordpress"
}

variable "suffix" {
  description = "Suffix used to distinguish primary and secondary resources"
  type        = string
  default     = "eu"
}


variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
  default     = "default"
}

variable "instance_name" {
  description = "The desired name to assign to the deployed instance"
  default     = "container-vm-terraform"
}

variable "zone" {
  description = "The GCP zone to deploy instances into"
  type        = string
  default     = "us-central1-a"
}


variable "region" {
  description = "The GCP region to deploy instances into"
  type        = string
  default     = "us-central1"
}


variable "gke_location" {
  description = "The GCP zone to deploy GKE control plane and nodes"
  type        = string
  default     = "us-central1-a"
}


variable "username" {
  description = "The username for SSH access to the compute instance"
  default     = "x00204385"
}


# define the GCP authentication file
variable "gcp_auth_file" {
  type        = string
  description = "GCP authentication file"
}

# define GCP project name
variable "app_project" {
  type        = string
  description = "GCP project name"
  default     = "TUDPROJ"
}

# define GCP region
variable "gcp_region_1" {
  type        = string
  description = "GCP region"
}

# define GCP zone
variable "gcp_zone_1" {
  type        = string
  description = "GCP zone"
}

# define Public subnet
variable "public_subnet_cidr_1" {
  type        = string
  description = "Public subnet CIDR 1"
}

# define Public subnet
variable "public_subnet_cidr_2" {
  type        = string
  description = "Public subnet CIDR 2"
}

# define Public subnet
variable "private_subnet_cidr_1" {
  type        = string
  description = "Private subnet CIDR 1"
}

# define Public subnet
variable "private_subnet_cidr_2" {
  type        = string
  description = "Private subnet CIDR 2"
}

# GKE control plane IP range
variable "master_ipv4_cidr_block" {
  description = "CIDR to use for control plane in GKE cluster"
  type        = string
  default     = null
}

# GKE secondary IP ranges
variable "gke_pod_ip_range" {
  type        = string
  description = "Secondary IP range for GKE pods"
}

variable "gke_services_ip_range" {
  type        = string
  description = "Secondary IP range for GKE services"
}


# GKE variables
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
