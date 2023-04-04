# terraform-google-workload-identity

[`Workload Identity`](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) is the recommended way to access GCP services from Kubernetes.

This module creates:

* IAM Service Account binding to `roles/iam.workloadIdentityUser`
* Optionally, a Google Service Account
* Optionally, a Kubernetes Service Account

## Usage

The `terraform-google-workload-identity` can create service accounts for you,
or you can use existing accounts; this applies for both the Google and
Kubernetes accounts.

### Creating a Workload Identity

```hcl
module "my-app-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "my-application-name"
  namespace           = "default"
  project_id          = "my-gcp-project-name"
  roles               = ["roles/storage.admin", "roles/compute.admin"]
  additional_projects = {"my-gcp-project-name1" : ["roles/storage.admin", "roles/compute.admin"],
                         "my-gcp-project-name2" : ["roles/storage.admin", "roles/compute.admin"]}
}
```

This will create:

* Google Service Account named: `my-application-name@my-gcp-project-name.iam.gserviceaccount.com`
* Kubernetes Service Account named: `my-application-name` in the `default` namespace
* IAM Binding (`roles/iam.workloadIdentityUser`) between the service accounts

Usage from a Kubernetes deployment:

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

### Using an existing Google Service Account

An existing Google service account can optionally be used.

```hcl
resource "google_service_account" "preexisting" {
  account_id   = "preexisting-sa"
}

module "my-app-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_gcp_sa = true
  name                = google_service_account.preexisting.account_id
  project_id          = var.project_id

  # wait for the custom GSA to be created to force module data source read during apply
  # https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1059
  depends_on = [google_service_account.preexisting]
}
```

### Using an existing Kubernetes Service Account

An existing Kubernetes service account can optionally be used.

```hcl
resource "kubernetes_service_account" "preexisting" {
  metadata {
    name      = "preexisting-sa"
    namespace = "prod"
  }
}

module "my-app-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_k8s_sa = true
  cluster_name        = "my-k8s-cluster-name"
  location            = "my-k8s-cluster-location"
  name                = kubernetes_service_account.preexisting.metadata[0].name
  namespace           = kubernetes_service_account.preexisting.metadata[0].namespace
  project_id          = var.project_id
}
```

If annotation is disabled (via `annotate_k8s_sa = false`), the existing Kubernetes service account must
already bear the `"iam.gke.io/gcp-service-account"` annotation.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_projects | A list of roles to be added to the created service account for additional projects | `map(list(string))` | `{}` | no |
| annotate\_k8s\_sa | Annotate the kubernetes service account with 'iam.gke.io/gcp-service-account' annotation. Valid in cases when an existing SA is used. | `bool` | `true` | no |
| automount\_service\_account\_token | Enable automatic mounting of the service account token | `bool` | `false` | no |
| cluster\_name | Cluster name. Required if using existing KSA. | `string` | `""` | no |
| gcp\_sa\_name | Name for the Google service account; overrides `var.name`. | `string` | `null` | no |
| impersonate\_service\_account | An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials. | `string` | `""` | no |
| k8s\_sa\_name | Name for the Kubernetes service account; overrides `var.name`. `cluster_name` and `location` must be set when this input is specified. | `string` | `null` | no |
| k8s\_sa\_project\_id | GCP project ID of the k8s service account; overrides `var.project_id`. | `string` | `null` | no |
| location | Cluster location (region if regional cluster, zone if zonal cluster). Required if using existing KSA. | `string` | `""` | no |
| module\_depends\_on | List of modules or resources to depend on before annotating KSA. If multiple, all items must be the same type. | `list(any)` | `[]` | no |
| name | Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary. | `string` | n/a | yes |
| namespace | Namespace for the Kubernetes service account | `string` | `"default"` | no |
| project\_id | GCP project ID | `string` | n/a | yes |
| roles | A list of roles to be added to the created service account | `list(string)` | `[]` | no |
| use\_existing\_context | An optional flag to use local kubectl config context. | `bool` | `false` | no |
| use\_existing\_gcp\_sa | Use an existing Google service account instead of creating one | `bool` | `false` | no |
| use\_existing\_k8s\_sa | Use an existing kubernetes service account instead of creating one | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| gcp\_service\_account | GCP service account. |
| gcp\_service\_account\_email | Email address of GCP service account. |
| gcp\_service\_account\_fqn | FQN of GCP service account. |
| gcp\_service\_account\_name | Name of GCP service account. |
| k8s\_service\_account\_name | Name of k8s service account. |
| k8s\_service\_account\_namespace | Namespace of k8s service account. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
