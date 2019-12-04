# Shared VPC Cluster

This example demonstrates how to create a simple cluster using the shared VPC helper submodule.
The network will be deployed in the host project and the cluster will be deployed in the service project.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | The region to host the cluster in | string | `"us-central1"` | no |
| svpc\_host\_project\_id | The GCP project housing the VPC network to host the cluster in | string | n/a | yes |
| svpc\_service\_project\_id | The service project ID to host the cluster in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| client\_token | The OAuth2 access token (base64 encoded) used by the client to authenticate against the Google Cloud API. |
| cluster\_name | The Cluster name |
| host\_project\_id | The project ID of the shared VPC's host |
| host\_project\_number | The project number of the shared VPC's host |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint | Cluster endpoint |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| master\_kubernetes\_version | The master Kubernetes version |
| network | The Shared VPC host project network the cluster is hosted in |
| project\_id | The project ID the cluster is created in |
| project\_number | The project number the cluster is created in |
| region | The region the cluster is hosted in |
| service\_account | The default service account used for running nodes. |
| subnetwork | The subnet the cluster is hosted in |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Install

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
