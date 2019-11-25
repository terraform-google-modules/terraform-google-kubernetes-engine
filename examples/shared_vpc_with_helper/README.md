# Shared VPC Cluster

This example illustrates how to create a simple cluster using shared VPC helper submodule
where the host network belong to shared vpc host project but the cluster to service project.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| billing\_account | The billing account id associated with the project, e.g. XXXXXX-YYYYYY-ZZZZZZ | string | n/a | yes |
| gke\_service\_project | The service project ID to host the cluster in | string | n/a | yes |
| gke\_shared\_host\_project | The GCP project housing the VPC network to host the cluster in | string | n/a | yes |
| org\_id | The numeric organization id | string | n/a | yes |
| region | The region to host the cluster in | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate |  |
| client\_token |  |
| cluster\_name | Cluster name |
| host\_project\_id |  |
| host\_project\_number |  |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint |  |
| location |  |
| master\_kubernetes\_version | The master Kubernetes version |
| network |  |
| project\_id |  |
| project\_number |  |
| region |  |
| service\_account | The default service account used for running nodes. |
| subnetwork |  |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
