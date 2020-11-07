# Simple Zonal Cluster

This example illustrates how to create a simple cluster and register it with [Anthos](https://cloud.google.com/anthos/multicluster-management/environs)

It incorporates the standard cluster module and the [Hub registration module](../../modules/hub).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| ip\_range\_pods | The secondary ip range to use for pods | `string` | `""` | no |
| ip\_range\_services | The secondary ip range to use for services | `string` | `""` | no |
| network | The VPC network to host the cluster in | `string` | `"default"` | no |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | `string` | `"default"` | no |
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

Example:

```
terraform init

terraform apply \
    -var project_id=${PROJECT} \
    -var region="us-central1" \
    -var zones='["us-central1-c"]'
```
