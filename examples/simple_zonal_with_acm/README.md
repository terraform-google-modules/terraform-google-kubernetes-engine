# Simple Zonal Cluster

This example illustrates how to create a simple cluster and install [Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/).

It incorporates the standard cluster module and the [ACM install module](../../modules/acm).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acm\_policy\_dir | Subfolder containing configs in ACM Git repo | `string` | `"foo-corp"` | no |
| acm\_sync\_branch | Anthos config management Git branch | `string` | `"1.0.0"` | no |
| acm\_sync\_repo | Anthos config management Git repo | `string` | `"git@github.com:GoogleCloudPlatform/csp-config-management.git"` | no |
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| operator\_path | Path to the operator yaml config. If unset, will download from GCS releases. | `string` | `null` | no |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |
| zones | The zone to host the cluster in (required if is a zonal cluster) | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| acm\_git\_creds\_public | Public key of SSH keypair to allow the Anthos Operator to authenticate to your Git repository. |
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint | n/a |
| location | n/a |
| master\_kubernetes\_version | The master Kubernetes version |
| network | n/a |
| project\_id | n/a |
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
