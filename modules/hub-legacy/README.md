# Hub Submodule

**Note**: This module is legacy. For registering GKE clusters, you should switch to the new, native [module](../fleet-membership).

This module [registers a Kubernetes cluster](https://cloud.google.com/anthos/multicluster-management/connect/registering-a-cluster) in an Anthos [Environ](https://cloud.google.com/anthos/multicluster-management/environs).

Specifically, this module automates the following steps for [registering a cluster](https://cloud.google.com/anthos/multicluster-management/connect/registering-a-cluster#register_cluster).

## Usage

There is [GKE full example](../../examples/simple_zonal_with_asm) and a [Generic K8s example](../../examples/simple_zonal_with_hub_kubeconfig) provided. Simple usage is as follows:

```tf
module "hub" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/hub"

  project_id       = "my-project-id"
  cluster_name     = "my-cluster-name"
  location         = module.gke.location
  cluster_endpoint = module.gke.endpoint
}
```

To deploy this config:
1. Run `terraform apply`

## Requirements

- Anthos [Environs](https://cloud.google.com/anthos/multicluster-management/environs) require an active Anthos license.



 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_endpoint | The GKE cluster endpoint. | `string` | n/a | yes |
| cluster\_name | The unique name to identify the cluster in ASM. | `string` | n/a | yes |
| gcloud\_sdk\_version | The gcloud sdk version to use. Minimum required version is 293.0.0 | `string` | `"296.0.1"` | no |
| gke\_hub\_membership\_name | Membership name that uniquely represents the cluster being registered on the Hub | `string` | `"gke-hub-membership"` | no |
| gke\_hub\_sa\_name | Name for the GKE Hub SA stored as a secret `creds-gcp` in the `gke-connect` namespace. | `string` | `"gke-hub-sa"` | no |
| hub\_project\_id | The project in which the GKE Hub belongs. | `string` | `""` | no |
| labels | Comma separated labels in the format name=value to apply to cluster in the GCP Console. | `string` | `""` | no |
| location | The location (zone or region) this cluster has been created in. | `string` | n/a | yes |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| project\_id | The project in which the resource belongs. | `string` | n/a | yes |
| sa\_private\_key | Private key for service account base64 encoded. Required only if `use_existing_sa` is set to `true`. | `string` | `null` | no |
| use\_existing\_sa | Uses an existing service account to register membership. Requires sa\_private\_key | `bool` | `false` | no |
| use\_kubeconfig | Use existing kubeconfig to register membership. Set this to true for non GKE clusters. Assumes kubectl context is set to cluster to register. | `bool` | `false` | no |
| use\_tf\_google\_credentials\_env\_var | Optional GOOGLE\_CREDENTIALS environment variable to be activated. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| wait | An output to use when you want to depend on registration finishing |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
