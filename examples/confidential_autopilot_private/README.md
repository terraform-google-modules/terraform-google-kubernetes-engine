# Confidential Autopilot Private Cluster

This example illustrates how to create an Autopilot cluster with beta features,
using Confidential GKE nodes and a Customer Managed Encryption Keys (CMEK).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Cluster name |
| kms\_key | CMEK used for disk and database encryption |
| kubernetes\_endpoint | The cluster endpoint |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| master\_kubernetes\_version | Kubernetes version of the master |
| network\_name | The name of the VPC being created |
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
