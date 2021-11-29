# Upgrading to v18.0

The v18.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 4.0 or higher of
the Google Cloud Platform Provider.

```diff
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
-      version = "~> 3.0"
+      version = "~> 4.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
-      version = "~> 3.0"
+      version = "~> 4.0"
    }

  }
}
```

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

### Acceptable values for node_metadata modified
The `node_metadata` variable should now be set to one of `GKE_METADATA`,
`GCE_METADATA` or `UNSPECIFIED`. `GKE_METADATA` replaces the previous
`GKE_METADATA_SERVER` value, `GCE_METADATA` should be used in place of
`EXPOSE`. The `SECURE` option, previously deprecated, has now been removed.

```diff
module "gke" {
  source = "../../modules/safer-cluster"

  node_pools = [
    {

-     node_metadata = "GKE_METADATA_SERVER"
+     node_metadata = "GKE_METADATA"
    }
  ]
}
```

### node_pools_versions is now keyed by node-pool name
The `node_pools_versions` output is now an object keyed by node pool name,
rather than a list as previously.
