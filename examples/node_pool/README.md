# Node Pool Cluster

This example illustrates how to create a cluster with multiple custom node-pool configurations with node labels, taints, and network tags.

[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials_path | The path to a Google Cloud Service Account credentials file | string | - | yes |
| ip_range_pods | The secondary ip range to use for pods | string | - | yes |
| ip_range_services | The secondary ip range to use for pods | string | - | yes |
| network | The VPC network to host the cluster in | string | - | yes |
| pool_01_service_account | Service account to associate to the nodes on pool-01. Only needed if you have deleted or otherwise don't want to use the default compute service account | string | - | yes |
| project_id | The project ID to host the cluster in | string | - | yes |
| region | The region to host the cluster in | string | - | yes |
| subnetwork | The subnetwork to host the cluster in | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| client_token |  |
| cluster_name | Cluster name |
| ip_range_pods | The secondary IP range used for pods |
| ip_range_services | The secondary IP range used for services |
| kubernetes_endpoint |  |
| location |  |
| network |  |
| project_id |  |
| region_example |  |
| subnetwork |  |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure