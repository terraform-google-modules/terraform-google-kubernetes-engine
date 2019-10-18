# Simple Regional Cluster with Networking

This example illustrates how to create a VPC and a simple cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | string | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | string | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | string | n/a | yes |
| ip\_range\_services | The secondary ip range to use for pods | string | n/a | yes |
| network\_name | The VPC network created to host the cluster in | string | n/a | yes |
| project\_id | The project ID to host the cluster in | string | n/a | yes |
| region | The region to host the cluster in | string | n/a | yes |
| subnetwork | The subnetwork created to host the cluster in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate |  |
| client\_token |  |
| kubernetes\_endpoint |  |
| network\_name | The name of the VPC being created |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| subnet\_names | The name of the subnet being created |
| subnet\_secondary\_ranges | The secondary ranges associated with the subnet |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
