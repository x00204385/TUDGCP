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


# define GCP zone
variable "gcp_zone_1" {
  type        = string
  description = "GCP zone"
}


variable "asg_subnets" {
  description = "Subnet ids used for VM deployment"
  type        = list(string)
  default     = null
}

variable "suffix" {
  description = "Suffix used to distinguish primary and secondary resources"
  type        = string
  default     = null
}

variable "mount_point" {
  description = "Filestore mount point used by the VM instances"
  type        = string
  default     = null
}

variable "db_ip_address" {
  description = "Address of Cloud SQL used for database services for web applications"
  type        = string
  default     = null
}



# Load balancer variables | lb-managed-variables.tf

# maximum number of VMs for load balancer autoscale
variable "lb_max_replicas" {
  type        = string
  description = "Maximum number of VMs for autoscale"
  default     = 6
}

# minimum number of VMs for load balancer autoscale
variable "lb_min_replicas" {
  type        = string
  description = "Minimum number of VMs for autoscale"
  default     = 2
}

# number of seconds that the autoscaler should wait before it starts collecting information
variable "lb_cooldown_period" {
  type        = string
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance"
  default     = 300
}

