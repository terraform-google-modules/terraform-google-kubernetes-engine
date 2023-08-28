# Simple Regional Cluster

This example illustrates how to create a simple private cluster with beta features.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudrun | Boolean to enable / disable CloudRun | string | `"true"` | no |
| cluster\_name\_suffix | A suffix to append to the default cluster name | string | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | string | n/a | yes |
| credentials\_path | The path to the GCP credentials JSON file | string | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | string | n/a | yes |
| ip\_range\_services | The secondary ip range to use for pods | string | n/a | yes |
| istio | Boolean to enable / disable Istio | string | `"true"` | no |
| network | The VPC network to host the cluster in | string | n/a | yes |
| project\_id | The project ID to host the cluster in | string | n/a | yes |
| region | The region to host the cluster in | string | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate |  |
| client\_token |  |
| cluster\_name | Cluster name |
| credentials\_path |  |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint |  |
| location |  |
| master\_kubernetes\_version | The master Kubernetes version |
| network |  |
| project\_id |  |
| region |  |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| subnetwork |  |
| zones | List of zones in which the cluster resides |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
