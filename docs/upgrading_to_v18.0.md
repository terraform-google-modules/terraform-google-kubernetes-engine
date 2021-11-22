# Upgrading to v18.0

The v18.0 release of *kubernetes-engine* is a backwards incompatible release.

### Kubernetes Basic Authentication removed
Basic authentication is deprecated and has been removed in GKE 1.19 and later.
Owing to this, the `basic_auth_username` and `basic_auth_password` variables
have been eliminated.

```diff
 module "gke" {
   source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
-  version = "~> 17.0"
+  version = "~> 18.0"

-  basic_auth_username = "admin"
-  basic_auth_password = "s3crets!"
}
```

### identity_namespace renamed to workload_pool
The `identity_namespace` variable has been renamed for consistency with the
Kubernetes API; the behavior (e.g. enabling Workload Identity by default)
remains the same.

```diff
 module "gke" {
   source  = "terraform-google-modules/kubernetes-engine/google"
-  version = "~> 17.0"
+  version = "~> 18.0"

-  identity_namespace = null
+  workload_pool      = null
}
```
