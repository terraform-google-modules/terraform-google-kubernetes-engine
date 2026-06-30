# Upgrading to v45.0

The v45.0 release of *terraform-google-kubernetes-engine* contains breaking interface changes in the `workload-identity` submodule.

## Workload Identity Submodule (`modules/workload-identity`)

### 1. Native `kubernetes_annotations` Replacement

The `workload-identity` submodule no longer uses `kubectl-wrapper` (`local-exec` bash script execution) to annotate existing Kubernetes Service Accounts. Instead, it uses the native [`kubernetes_annotations`](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/annotations) resource from the `hashicorp/kubernetes` provider.

#### Kubernetes Provider Prerequisite
Because `kubernetes_annotations` is a native Terraform provider resource, callers **must** have an initialized and authenticated `kubernetes` provider configured in their root module context:

```hcl
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
```

> **Note:** If you previously configured `ignore_annotations` in your `kubernetes` provider block to ignore Workload Identity annotations (e.g., `ignore_annotations = ["^iam.gke.io\\/.*"]`) to prevent conflicts with the legacy `kubectl-wrapper`, you must remove that configuration. Otherwise, the new native `kubernetes_annotations` resource will not function correctly.

---

### 2. Removed Input Variables

The following input variables were previously used to configure `gcloud container clusters get-credentials` and `kubectl` inside `kubectl_wrapper.sh`. They have been removed as they are no longer required by the module:

- `cluster_name`
- `location`
- `impersonate_service_account`
- `use_existing_context`

#### Expected Error if Unchanged
If you attempt to apply module calls containing these deleted inputs, Terraform will return an error during configuration validation:

```text
Error: Unsupported argument

  on main.tf line 32, in module "workload_identity":
  32:   cluster_name = module.gke.name

An argument named "cluster_name" is not expected here.
```

#### Migration Example

Update your `module "workload_identity"` calls to remove the deleted arguments:

```diff
module "workload_identity" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
-  version = "~> 44.0"
+  version = "~> 45.0"

  project_id          = var.project_id
  name                = "my-app"
-  cluster_name        = module.gke.name
-  location            = module.gke.location
  namespace           = "default"
  use_existing_k8s_sa = true
  k8s_sa_name         = "existing-ksa"
}
```

---

### 3. State Migration Strategy

For existing deployments where `use_existing_k8s_sa = true` and `annotate_k8s_sa = true`:

1. Terraform will plan to destroy the legacy `module.annotate-sa` resources and create `kubernetes_annotations.main[0]`.
2. `kubernetes_annotations.main[0]` uses `force = true` and Server-Side Apply to adopt the existing `"iam.gke.io/gcp-service-account"` annotation seamlessly.
3. **Proactive State Cleanup for CI/CD Runners:** Standard CI/CD runner environments (Terraform Cloud, Spacelift, Atlantis, minimal GitHub Actions runners) typically lack local `gcloud` and `kubectl` binaries. Attempting to run `terraform apply` directly may fail during the destroy phase of `module.annotate-sa`.

To prevent build failures, remove the legacy module state **prior to running `terraform apply`**:

```bash
# Standard module call
terraform state rm 'module.workload_identity.module.annotate-sa'

# Module call using count or for_each
terraform state rm 'module.workload_identity["app"].module.annotate-sa'
terraform state rm 'module.workload_identity[0].module.annotate-sa'
```

*Note: Deployments created with `use_existing_k8s_sa = false` (default) do not use `module.annotate-sa` and require no state migration.*
