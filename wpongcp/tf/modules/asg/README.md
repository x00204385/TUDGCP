## Autoscaling group terraform module
Terraform module to create a load balancer with associated managed instance group. Managed instance group deploys software using input script. Requires a Google File Store instance for shared storage between the VM instances. Also requires a Cloud SQL instance which is used for database services.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_autoscaler.autoscaler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_autoscaler) | resource |
| [google_compute_backend_service.backend_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_forwarding_rule.global_forwarding_rule](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_health_check.autohealing](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_health_check.healthcheck](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_health_check) | resource |
| [google_compute_instance_group_manager.web_private_group](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager) | resource |
| [google_compute_instance_template.web_server](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_template) | resource |
| [google_compute_target_http_proxy.target_http_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_url_map.url_map](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_subnets"></a> [asg\_subnets](#input\_asg\_subnets) | Subnet ids used for VM deployment | `list(string)` | `null` | no |
| <a name="input_db_ip_address"></a> [db\_ip\_address](#input\_db\_ip\_address) | Address of Cloud SQL used for database services for web applications | `string` | `null` | no |
| <a name="input_gcp_zone_1"></a> [gcp\_zone\_1](#input\_gcp\_zone\_1) | GCP zone | `string` | n/a | yes |
| <a name="input_lb_cooldown_period"></a> [lb\_cooldown\_period](#input\_lb\_cooldown\_period) | The number of seconds that the autoscaler should wait before it starts collecting information from a new instance | `string` | `300` | no |
| <a name="input_lb_max_replicas"></a> [lb\_max\_replicas](#input\_lb\_max\_replicas) | Maximum number of VMs for autoscale | `string` | `6` | no |
| <a name="input_lb_min_replicas"></a> [lb\_min\_replicas](#input\_lb\_min\_replicas) | Minimum number of VMs for autoscale | `string` | `2` | no |
| <a name="input_mount_point"></a> [mount\_point](#input\_mount\_point) | Filestore mount point used by the VM instances | `string` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The network to which we deploy the resources | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to deploy resources into | `string` | `null` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix used to distinguish primary and secondary resources | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_ip_address"></a> [load\_balancer\_ip\_address](#output\_load\_balancer\_ip\_address) | TThe public IP address of the load balancer |
<!-- END_TF_DOCS -->