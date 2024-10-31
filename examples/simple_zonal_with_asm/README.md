# Simple Zonal Cluster with ASM

This example illustrates how to create a simple zonal cluster with ASM.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_fleet\_feature | Whether to enable the Mesh feature on the fleet. | `bool` | `true` | no |
| mesh\_management | ASM Management mode. For more information, see the [gke\_hub\_feature\_membership resource documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#nested_mesh) | `string` | `"MANAGEMENT_AUTOMATIC"` | no |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| zone | The zone to host the cluster in (required if is a zonal cluster) | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| location | Cluster Location |
| network | Network name |
| project\_id | Project ID |
| region | Cluster Region |
| service\_account | The default service account used for running nodes. |
| subnetwork | Subnetwork name |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
