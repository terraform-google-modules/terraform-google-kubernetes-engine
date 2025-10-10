# Simple Zonal Cluster

This example illustrates how to create a simple cluster and register it with [Anthos](https://cloud.google.com/anthos/multicluster-management/connect/registering-a-cluster#gcloud).

After registering the cluster, it uses that registration to install [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview).

It incorporates the standard cluster module, the [registration module](../../modules/fleet-membership), and the [ACM module](../../modules/acm).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `string` | `"us-central1"` | no |
| zone | The zone to host the cluster in | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| hub\_location | The location of the hub membership. |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubernetes\_endpoint | n/a |
| location | n/a |
| master\_kubernetes\_version | The master Kubernetes version |
| network | n/a |
| project\_id | Standard test outputs |
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
