# Kind Cluster Registered using kubeconfig

This example illustrates how to register a non-GKE Kubernetes Cluster with [Anthos](https://cloud.google.com/anthos/multicluster-management/environs) a.k.a Attached cluster.

It creates a [kind](https://kind.sigs.k8s.io/) cluster, sets current kubecontext to the cluster and registers the cluster using the [Hub registration module](../../modules/hub).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| kubernetes\_endpoint | Kube API endpoint for the kind cluster |

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
```
