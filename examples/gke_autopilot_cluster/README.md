# GKE Autopilot Cluster

This example creates a GKR private Autopilot clusterwith beta features.
For a full example see [simple_autopilot_private](../simple_autopilot_private/README.md) example.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| addons\_config | The configuration for addons supported by GKE Autopilot. |
| ca\_certificate | The cluster ca certificate (base64 encoded) |
| cluster\_name | Cluster name |
| endpoint | The cluster endpoint |
| location | Cluster location |
| master\_version | The master Kubernetes version |
| network\_name | The name of the VPC being created |
| node\_locations | Cluster node locations |
| project\_id | The project ID the cluster is in |
| subnets\_names | The names of the subnet being created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
