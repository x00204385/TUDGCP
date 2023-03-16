variable "project_id" {
  description = "The project ID to deploy resources into"
  type   = string
  default = "tudproj-380715"
}

variable "subnetwork" {
  description = "The name of the subnetwork to deploy instances into"
  default = "default"
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

variable "client_email" {
  description = "Service account email address"
  type        = string
  default     = ""
}

variable "username" {
  description = "The username for SSH access to the compute instance"
  default = "x00204385"
}
