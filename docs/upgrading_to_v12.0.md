# Upgrading to v12.0

The v12.0 release of *kubernetes-engine* is a backwards incompatible
release.

### ASM module

- GKE Hub functionality has been removed from ASM module.
- This is destructive and will result in the destruction and reapplication of the hub agent.

```diff
 module "acm" {
   source               = "terraform-google-modules/kubernetes-engine/google//modules/asm"
-  version              = "~> 11.0"
+  version              = "~> 12.0"
}
+ module "hub" {
+   source               = "terraform-google-modules/kubernetes-engine/google//modules/hub"
+  version               = "~> 12.0"
}
```

### Dropped support for `gcloud_skip_download` variable across all modules/submodules

- The `gcloud_skip_download` has been removed in favor of a simplified environment variable flag.
- Setting environment variable `GCLOUD_TF_DOWNLOAD` to `always` will download and install gcloud and is equivalent to `gcloud_skip_download = false`.

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