# GKE Standard Cluster and Node Pool

This example creates a GKE private cluster and Node Pool with beta features.
For a full example see [simple_regional_private_beta](../simple_regional_private_beta/README.md) example.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| dns\_cache | Boolean to enable / disable NodeLocal DNSCache | `bool` | `false` | no |
| gce\_pd\_csi\_driver | (Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. | `bool` | `false` | no |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| service\_account | Service account to associate to the nodes in the cluster | `any` | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| addons\_config | The configuration for addons supported by GKE Autopilot. |
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| cluster\_name | Cluster name |
| endpoint | The cluster endpoint |
| location | Cluster location |
| master\_version | The master Kubernetes version |
| node\_locations | Cluster node locations |
| project\_id | The project ID the cluster is in |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
