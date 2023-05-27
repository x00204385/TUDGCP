variable "suffix" {
  description = "Suffix used to distinguish primary and secondary resources"
  type        = string
  default     = "eu"
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

variable "primary" {
  type        = bool
  description = "Determine whether this is the primary or standby region"
}

