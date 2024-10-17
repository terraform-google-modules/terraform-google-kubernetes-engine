# Simple Zonal Cluster

This example illustrates how to create a simple cluster and install [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) with the [Pod Security Standards Baseline policy bundle](https://cloud.google.com/kubernetes-engine/enterprise/policy-controller/docs/how-to/using-pss-baseline).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| enable\_fleet\_feature | Whether to enable the Policy Controller feature on the fleet. | `bool` | `true` | no |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| zone | The zone to host the cluster in | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| location | n/a |
| network | n/a |
| project\_id | Standard test outputs |
| region | n/a |
| service\_account | The default service account used for running nodes. |
| subnetwork | n/a |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
