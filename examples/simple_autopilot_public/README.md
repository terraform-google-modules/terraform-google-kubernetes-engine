# Simple Regional Cluster

This example illustrates how to create a simple cluster with beta features.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region the cluster in | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| cluster\_name | Cluster name |
| kubernetes\_endpoint | The cluster endpoint |
| location | n/a |
| master\_kubernetes\_version | Kubernetes version of the master |
| network\_name | The name of the VPC being created |
| project\_id | The project ID the cluster is in |
| region | The region in which the cluster resides |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| subnet\_names | The names of the subnet being created |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
