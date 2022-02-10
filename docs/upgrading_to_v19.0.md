# Upgrading to v19.0

The v19.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 4.0 or higher of
the Google Cloud Platform Provider and 4.3 or higher of
the Google Cloud Platform Beta Provider.

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
+      version = "~> 4.3"
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
It is recommended to update `node_metadata` variable to one of `GKE_METADATA`,
`GCE_METADATA` or `UNSPECIFIED`. `GKE_METADATA` replaces the previous
`GKE_METADATA_SERVER` value, `GCE_METADATA` should be used in place of
`EXPOSE`, however old values continue to be supported for backwards compatibility.
The `SECURE` option, previously deprecated, has now been removed.

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

### ⚠ Default node image changed to COS_CONTAINERD

⚠ This change in default may cause disruption to your workload as it will delete and recreate nodes in the node pool ⚠

The `COS` image is [deprecated](https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#cos-variants), therefore the default has been updated to `COS_CONTAINERD`. If you want to keep using the `COS` image for your node pool, you can override the default value.


```diff
module "gke" {
  source = "../../modules/safer-cluster"

  node_pools = [
    {
     name       = "pool-01"
+    image_type = "COS"
    }
  ]
}
```

### node_pools_versions is now keyed by node-pool name
The `node_pools_versions` output is now an object keyed by node pool name,
rather than a list as previously.
