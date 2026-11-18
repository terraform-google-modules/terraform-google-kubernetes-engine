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
resource "kubernetes_service_account_v1" "preexisting" {
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
  name                = kubernetes_service_account_v1.preexisting.metadata[0].name
  namespace           = kubernetes_service_account_v1.preexisting.metadata[0].namespace
  project_id          = var.project_id
}
```

If annotation is disabled (via `annotate_k8s_sa = false`), the existing Kubernetes service account must
already bear the `"iam.gke.io/gcp-service-account"` annotation.

## Using with multiple clusters

This module accommodates configurations involving multiple clusters within the kubernetes provider.

To begin, initialize the kubernetes provider for each cluster with a unique alias, as demonstrated below:

Initialize your `kubernetes` provider with an alias like the following:

```hcl
provider "kubernetes" {
  alias                  = "alias-for-your-cluster"
  host                   = "https://your-cluster-host-url.com"
  token                  = "your-cluster-token"
  cluster_ca_certificate = base64decode("Your-Cluster-Certificate")
}
```

Ensure each cluster configuration has a distinct alias. Repeat this step for every cluster you intend to manage.

In your module configuration, include the providers attribute to assign the appropriate provider alias:

```hcl
module "workload_identity_for_cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"

  providers = {
    kubernetes = kubernetes.alias-for-your-cluster
  }

  name        = "service-account-name"
  namespace   = "desired-namespace"
  // Other module configurations
}
```

This approach is required when managing multiple clusters. Omitting this step can lead to errors like the one shown below:

```shell
Error: Get "http://localhost/api/v1/namespaces/default/serviceaccounts/your-service-account": dial tcp [::1]:80: connect: connection refused
│
│   with module.your_workload_identity.kubernetes_service_account_v1.main[0],
│   on .terraform/modules/your_workload_identity/modules/workload-identity/main.tf line 52, in resource "kubernetes_service_account_v1" "main":
│   52: resource "kubernetes_service_account_v1" "main" {
```

## Upgrading from 44.2.0 or earlier

Since 44.3.0 the Kubernetes service account is `kubernetes_service_account_v1.main`. Before that it was `kubernetes_service_account.main`. The `hashicorp/kubernetes` provider does not implement `MoveResourceState` for this resource type, so Terraform cannot move the state by itself ([#2616](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/2616)).

If your state still has the old address, the plan replaces the service account: the old object is deleted and a new one with the same name is created. To keep the existing object, change the type in the state before you plan:

```bash
terraform state pull > state.json
jq '.resources |= map(if .type == "kubernetes_service_account" and .name == "main" and (.module == "module.workload_identity" or (.module // "" | startswith("module.workload_identity["))) then .type = "kubernetes_service_account_v1" else . end) | .serial += 1' state.json > state.new.json
terraform state push state.new.json
```

Replace `module.workload_identity` with the address of your module call as `terraform state list` shows it, without the trailing `["key"]` part. The `startswith` check picks up calls that use `count` or `for_each`. Both resource types have the same schema, so changing the type is enough.

You can also move one service account at a time:

```bash
terraform state rm 'module.workload_identity.kubernetes_service_account.main[0]'
terraform import 'module.workload_identity.kubernetes_service_account_v1.main[0]' my-namespace/my-service-account
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_projects | A list of roles to be added to the created service account for additional projects | `map(list(string))` | `{}` | no |
| annotate\_k8s\_sa | Annotate the kubernetes service account with 'iam.gke.io/gcp-service-account' annotation. Valid in cases when an existing SA is used. | `bool` | `true` | no |
| automount\_service\_account\_token | Enable automatic mounting of the service account token | `bool` | `false` | no |
| cluster\_name | Cluster name. Required if using existing KSA. | `string` | `""` | no |
| gcp\_sa\_create\_ignore\_already\_exists | If set to true, skip service account creation if a service account with the same email already exists. | `bool` | `null` | no |
| gcp\_sa\_description | The Service Google service account desciption; if null, will be left out | `string` | `null` | no |
| gcp\_sa\_display\_name | The Google service account display name; if null, a default string will be used | `string` | `null` | no |
| gcp\_sa\_name | Name for the Google service account; overrides `var.name`. | `string` | `null` | no |
| image\_pull\_secrets | A list of references to secrets in the same namespace to use for pulling any images in pods that reference this Service Account | `list(string)` | `[]` | no |
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
