# Deploy Service Cluster

This example illustrates how to deploy a service to the created cluster using the kubernetes provider.

It will:
- Create a cluster
- Configure authentication for the Kubernetes provider
- Create an Nginx Pod
- Create an Nginx Service

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
| ca_certificate |  |
| client_token |  |
| cluster_name | Cluster name |
| credentials_path |  |
| ip_range_pods | The secondary IP range used for pods |
| ip_range_services | The secondary IP range used for services |
| kubernetes_endpoint |  |
| location |  |
| master_kubernetes_version | The master Kubernetes version |
| network |  |
| project_id |  |
| region |  |
| subnetwork |  |
| zones | List of zones in which the cluster resides |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure