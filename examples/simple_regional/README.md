# Simple Regional Cluster

This example illustrates how to create a simple cluster.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ip_range_pods | The secondary ip range to use for pods | string | - | yes |
| ip_range_services | The secondary ip range to use for pods | string | - | yes |
| network | The VPC network to host the cluster in | string | - | yes |
| project_id | The project ID to host the cluster in | string | - | yes |
| region | The region to host the cluster in | string | - | yes |
| subnetwork | The subnetwork to host the cluster in | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_name | Cluster name |
| credentials_path |  |
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