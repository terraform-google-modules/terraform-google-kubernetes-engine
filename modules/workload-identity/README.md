# terraform-google-workload-identity

[`Workload Identity`](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) is the recommended way to access GCP services from Kubernetes.

This module creates:

* GCP Service Account
* IAM Service Account binding to `roles/iam.workloadIdentityUser`
* Optionally, a Kubernetes Service Account

## Usage

The `terraform-google-workload-identity` can create a kubernetes service account for you, or use an existing kubernetes service account.

### Creating a Workload Identity

```hcl
module "my-app-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "my-application-name"
  namespace  = "default"
  project_id = "my-gcp-project-name"
  roles = ["roles/storage.Admin", "roles/compute.Admin"]
}
```

This will create:

* GCP Service Account named: `my-application-name@my-gcp-project-name.iam.gserviceaccount.com`
* Kubernetes Service Account named: `my-application-name` in the `default` namespace
* IAM Binding (`roles/iam.workloadIdentityUser`) between the service accounts

Usage from a kubernetes deployment:

```yaml
metadata:
  namespace: default
  # ...
spec:
  # ...
  template:
    spec:
      serviceAccountName: my-application-name
```

### Using an existing Kubernetes Service Account

An existing kubernetes service account can optionally be used. When using an existing k8s servicea account the annotation `"iam.gke.io/gcp-service-account"` must be set.

```hcl
resource "kubernetes_service_account" "preexisting" {
  metadata {
    name = "preexisting-sa"
    namespace = "prod"
  }
}

module "my-app-workload-identity" {
  source    = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_k8s_sa = true
  name                = "preexisting-sa"
  namespace           = "prod"
  project_id          = var.project_id
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotate\_k8s\_sa | Annotate the kubernetes service account with 'iam.gke.io/gcp-service-account' annotation. Valid in cases when an existing SA is used. | `bool` | `true` | no |
| automount\_service\_account\_token | Enable automatic mounting of the service account token | `bool` | `false` | no |
| cluster\_name | Cluster name. Required if using existing KSA. | `string` | `""` | no |
| k8s\_sa\_name | Name for the existing Kubernetes service account | `string` | `null` | no |
| location | Cluster location (region if regional cluster, zone if zonal cluster). Required if using existing KSA. | `string` | `""` | no |
| name | Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary. | `string` | n/a | yes |
| namespace | Namespace for k8s service account | `string` | `"default"` | no |
| project\_id | GCP project ID | `string` | n/a | yes |
| roles | (optional) A list of roles to be added to the created Service account | `list(string)` | `[]` | no |
| use\_existing\_k8s\_sa | Use an existing kubernetes service account instead of creating one | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| gcp\_service\_account\_email | Email address of GCP service account. |
| gcp\_service\_account\_fqn | FQN of GCP service account. |
| gcp\_service\_account\_name | Name of GCP service account. |
| k8s\_service\_account\_name | Name of k8s service account. |
| k8s\_service\_account\_namespace | Namespace of k8s service account. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
