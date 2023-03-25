
variable "app_name" {
  description = "App name used to name various resources"
  type        = string
  default     = "wordpress"
}



variable "project_id" {
  description = "The project ID to deploy resources into"
  type        = string
  default     = "tudproj-380715"
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


variable "client_email" {
  description = "Service account email address"
  type        = string
  default     = ""
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
variable "private_subnet_cidr_1" {
  type        = string
  description = "Private subnet CIDR 1"
}