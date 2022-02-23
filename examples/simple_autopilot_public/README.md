# Simple Regional Cluster

This example illustrates how to create a simple cluster with beta features.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | `any` | n/a | yes |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region the cluster in | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| cluster\_name | Cluster name |
| kubernetes\_endpoint | n/a |
| network\_name | The name of the VPC being created |
| project\_id | n/a |
| region | The region in which the cluster resides |
| service\_account | The default service account used for running nodes. |
| subnet\_names | The names of the subnet being created |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
