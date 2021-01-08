# Upgrading to v13.0

The v13.0 release of *kubernetes-engine* is a backwards incompatible
release.

### `kubernetes` provider removed from the module

- `kubernetes` provider has been removed across all modules/submodules and need to be specified in the calling module.

To leverage Terraform v0.13 features such as custom variable validation and using `count`, `for_each` or `depends_on` in modules,
it is [required](https://www.terraform.io/docs/modules/providers.html#legacy-shared-modules-with-provider-configurations) that
a module does not contain any nested provider configuration and receives all of its provider configurations from the calling
module. This release adapts to this requirement.

```diff
+  data "google_client_config" "default" {}

+  provider "kubernetes" {
+    load_config_file       = false
+    host                   = "https://${module.gke.endpoint}"
+    token                  = data.google_client_config.default.access_token
+    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
+  }

 module "gke" {
   source                  = "terraform-google-modules/kubernetes-engine/google"
-  version                 = "~> 12.0"
+  version                 = "~> 13.0"
}
```
