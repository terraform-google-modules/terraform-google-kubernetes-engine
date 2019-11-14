# Regional Private Cluster with node pool and oauth scopes

This example illustrates how to create a private cluster with node pool specifications, oauth scopes along with required network and subnet creation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The project ID to host the cluster in | string | n/a | yes |
| cluster\_name | Name of the cluster | string | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | string | n/a | yes |
| ip\_range\_services | The secondary ip range to use for pods | string | n/a | yes |
| network | The VPC network to host the cluster in | string | n/a | yes |
| region | The region to host the cluster in | string | n/a | yes |
| subnetwork | The subnetwork to host the cluster in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_name | Cluster name |
| cluster\_type | Cluster type - Regional or Zonal |
| location | Cluster location |
| region | Cluster region |
| zones | List of zones in which the cluster resides |
| min\_master\_version | Minimum master kubernetes version |
| master\_authorized\_networks\_config | Networks from which access to master is permitted |
| master\_version | Current master kubernetes version |
| node\_pools\_names | List of node pools names |
| node\_pools\_versions | List of node pools versions |
| service\_account | The default service account used for running nodes. |
| network | Network module output |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
