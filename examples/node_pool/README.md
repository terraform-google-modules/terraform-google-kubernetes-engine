# Node Pool Cluster

This example illustrates how to create a cluster with multiple custom node-pool configurations with node labels, taints, and network tags.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_autoscaling | Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling) | <pre>object({<br>    enabled             = bool<br>    autoscaling_profile = string<br>    min_cpu_cores       = number<br>    max_cpu_cores       = number<br>    min_memory_gb       = number<br>    max_memory_gb       = number<br>    gpu_resources = list(object({<br>      resource_type = string<br>      minimum       = number<br>      maximum       = number<br>    }))<br>  })</pre> | <pre>{<br>  "autoscaling_profile": "BALANCED",<br>  "enabled": false,<br>  "gpu_resources": [],<br>  "max_cpu_cores": 0,<br>  "max_memory_gb": 0,<br>  "min_cpu_cores": 0,<br>  "min_memory_gb": 0<br>}</pre> | no |
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | `any` | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |
| zones | The zone to host the cluster in (required if is a zonal cluster) | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
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
