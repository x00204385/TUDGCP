## GKE cluster module
Terraform module to create a GKE instance that can be used to deploy workloads. Cluster is created as a private, zonal cluster with a spot instance based node group running in the same zone. 


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.primary_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [null_resource.update_kubeconfig](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gke_location"></a> [gke\_location](#input\_gke\_location) | The GCP zone to deploy GKE control plane and nodes | `string` | `null` | no |
| <a name="input_gke_subnet"></a> [gke\_subnet](#input\_gke\_subnet) | Subnet where GKE cluster and MIG will deploy | `string` | `null` | no |
| <a name="input_network"></a> [network](#input\_network) | The network to which we deploy the resources | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to deploy resources into | `string` | `null` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix used to distinguish primary and secondary resources | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes_cluster_host"></a> [kubernetes\_cluster\_host](#output\_kubernetes\_cluster\_host) | GKE Cluster Host |
| <a name="output_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#output\_kubernetes\_cluster\_name) | GKE Cluster Name |
<!-- END_TF_DOCS -->