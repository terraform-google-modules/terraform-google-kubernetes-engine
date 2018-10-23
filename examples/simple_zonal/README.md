# Simple Zonal Cluster

This example illustrates how to create a simple cluster.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials_path | The path to a Google Cloud Service Account credentials file | string | - | yes |
| ip_range_pods | The secondary ip range to use for pods | string | - | yes |
| ip_range_services | The secondary ip range to use for pods | string | - | yes |
| network | The VPC network to host the cluster in | string | - | yes |
| project_id | The project ID to host the cluster in | string | - | yes |
| region | The region to host the cluster in | string | - | yes |
| subnetwork | The subnetwork to host the cluster in | string | - | yes |
| zones | The zone to host the cluster in (required if is a zonal cluster) | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| client_token |  |
| cluster_name | Cluster name |
| ip_range_pods | The secondary IP range used for pods |
| ip_range_services | The secondary IP range used for services |
| kubernetes_endpoint | Cluster endpoint |
| location | Cluster location |
| master_kubernetes_version | The master Kubernetes version |
| network | Network the cluster is provisioned in |
| project_id |  |
| region |  |
| subnetwork | Subnetwork the cluster is provisioned in |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure