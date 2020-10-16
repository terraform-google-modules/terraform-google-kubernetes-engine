# Upgrading to v12.0

The v12.0 release of *kubernetes-engine* is a backwards incompatible
release.

### ASM module

- GKE Hub functionality has been removed from ASM module and is now available as a separate [Hub submodule](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/hub).
- This is destructive and will result in the destruction and reapplication of cluster registration and optional SA.

```diff
 module "asm" {
   source               = "terraform-google-modules/kubernetes-engine/google//modules/asm"
-  version              = "~> 11.0"
+  version              = "~> 12.0"
}
+ module "hub" {
+   source               = "terraform-google-modules/kubernetes-engine/google//modules/hub"
+  version               = "~> 12.0"
}
```

### Dropped support for `gcloud_skip_download` variable

- The `gcloud_skip_download` has been removed across all modules/submodules in favor of a simplified environment variable flag.
- Setting environment variable `GCLOUD_TF_DOWNLOAD` to `always` will download and install gcloud and is equivalent to `gcloud_skip_download = false`.
- Additional documentation is available [here](https://github.com/terraform-google-modules/terraform-google-gcloud#downloading).

### GA cluster defaults for new features

- GA clusters now enable Workload Identity by default.

If you would like to continue using the module without Workload Identity, you can override the default value.
```diff
 module "gke" {
   source               = "terraform-google-modules/kubernetes-engine/google"
-  version              = "~> 11.0"
+  version              = "~> 12.0"
+  identity_namespace   = null
}
```

- GA clusters now enable Shielded Nodes by default.

If you would like to continue using the module without Shielded Nodes, you can override the default value.
```diff
 module "gke" {
   source                  = "terraform-google-modules/kubernetes-engine/google"
-  version                 = "~> 11.0"
+  version                 = "~> 12.0"
+  enable_shielded_nodes   = false
}
```


### Provider Version
Support for Google provider versions older than v3.39 has been removed due to the introduction of [new features](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/644) in the GA module.
