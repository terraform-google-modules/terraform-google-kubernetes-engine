# Simple Regional Cluster

This example illustrates how to create a simple cluster with beta features.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | `any` | n/a | yes |
| database\_encryption | Application-layer Secrets Encryption settings. The object format is {state = string, key\_name = string}. Valid values of state are: "ENCRYPTED"; "DECRYPTED". key\_name is the name of a CloudKMS key. | `list(object({ state = string, key_name = string }))` | <pre>[<br>  {<br>    "key_name": "",<br>    "state": "DECRYPTED"<br>  }<br>]</pre> | no |
| dns\_cache | (Beta) The status of the NodeLocal DNSCache addon. | `bool` | `false` | no |
| enable\_binary\_authorization | Enable BinAuthZ Admission controller | `bool` | `false` | no |
| enable\_pod\_security\_policy | enabled - Enable the PodSecurityPolicy controller for this cluster. If enabled, pods must be valid under a PodSecurityPolicy to be created. | `bool` | `false` | no |
| gce\_pd\_csi\_driver | (Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. | `bool` | `false` | no |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| node\_pools | List of maps containing node pools | `list(map(string))` | <pre>[<br>  {<br>    "name": "default-node-pool"<br>  }<br>]</pre> | no |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |
| remove\_default\_node\_pool | Remove default node pool while setting up the cluster | `bool` | `false` | no |
| sandbox\_enabled | (Beta) Enable GKE Sandbox (Do not forget to set `image_type` = `COS_CONTAINERD` and `node_version` = `1.12.7-gke.17` or later to use it). | `bool` | `false` | no |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| identity\_namespace | n/a |
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
