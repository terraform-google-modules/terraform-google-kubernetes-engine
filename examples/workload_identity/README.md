# Simple Zonal Cluster with Workload Identity

This example illustrates how to create a simple cluster, with a GCP service account bound as the identity running workloads on your GKE cluster.

Read more about [workload identity in the docs](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for pods | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| default\_wi\_email | GCP service account. |
| default\_wi\_ksa\_name | K8S SA name |
| existing\_gsa\_email | GCP service account. |
| existing\_gsa\_name | K8S SA name |
| existing\_ksa\_email | GCP service account. |
| existing\_ksa\_name | K8S SA name |
| kubernetes\_endpoint | n/a |
| location | Cluster location (zones) |
| project\_id | Project id where GKE cluster is created. |
| region | Cluster region |
| service\_account | The default service account used for running nodes. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
