# Safer GKE Cluster

This example illustrates how to instantiate the opinionated Safer Cluster module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudrun | Boolean to enable / disable CloudRun | string | `"true"` | no |
| cluster\_name\_suffix | A suffix to append to the default cluster name | string | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | string | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | string | `"ip-range-pods"` | no |
| ip\_range\_services | The secondary ip range to use for pods | string | `"ip-range-scv"` | no |
| istio | Boolean to enable / disable Istio | string | `"true"` | no |
| master\_auth\_subnetwork | The subnetwork that has access to cluster master | string | `"master-auth-subnet"` | no |
| master\_auth\_subnetwork\_cidr | The cidr block for the subnetwork that has access to cluster master | string | `"10.60.0.0/17"` | no |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network | string | `"172.16.0.0/28"` | no |
| network | The VPC network to host the cluster in | string | `"gke-network"` | no |
| project\_id | The project ID to host the cluster in | string | n/a | yes |
| region | The region to host the cluster in | string | `"us-central1"` | no |
| subnetwork | The subnetwork to host the cluster in | string | `"gke-subnet"` | no |
| subnetwork\_cidr | The cidr block for the subnetwork to host the cluster in | string | `"10.0.0.0/17"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| client\_token | The bearer token for auth |
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint | The cluster endpoint |
| location |  |
| master\_kubernetes\_version | The master Kubernetes version |
| network |  |
| network\_name | The name of the VPC being created |
| project\_id |  |
| region |  |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| subnet\_names | The names of the subnet being created |
| subnetwork |  |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
