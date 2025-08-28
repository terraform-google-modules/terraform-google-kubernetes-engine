# Confidential GPU GKE Cluster

This example illustrates how to instantiate the Beta Public Cluster module
with confidential nodes enabled, database encrypted with KMS key
and encrypted GPU Workload with NVIDIA Confidential Computing.
This module also installs the NVIDIA drivers on the GPU, so it's
ready to receive workloads.
See more: https://cloud.google.com/kubernetes-engine/docs/how-to/gpus-confidential-nodes.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in. | `string` | n/a | yes |
| region | The region to host the cluster in. | `string` | `"us-central1"` | no |
| zones | The zones to host the nodes in. The nodes must be in a zone that supports NVIDIA Confidential Computing. For more information, [view supported zones](https://cloud.google.com/confidential-computing/confidential-vm/docs/supported-configurations#nvidia-confidential-computing_1). | `list(string)` | <pre>[<br>  "us-central1-a"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster ca certificate (base64 encoded). |
| cluster\_name | Cluster name. |
| keyring | The name of the keyring. |
| kms\_key\_name | KMS Key Name. |
| kubernetes\_endpoint | The cluster endpoint. |
| location | n/a |
| master\_kubernetes\_version | Kubernetes version of the master. |
| network\_name | The name of the VPC being created. |
| project\_id | The project ID the cluster is in. |
| region | The region in which the cluster resides. |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| subnet\_names | The names of the subnet being created. |
| zones | List of zones in which the cluster resides. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
