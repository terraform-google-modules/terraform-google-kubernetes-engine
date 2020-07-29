# Upgrading to v11.0

The v11.0 release of *kubernetes-engine* is a backwards incompatible
release.

## In-cluster resources updated to use kubectl wrapper module

In order to avoid a permadiff while interacting with in-cluster resources, the following features/modules have been updated to use the new [kubectl wrapper](https://github.com/terraform-google-modules/terraform-google-gcloud/tree/master/modules/kubectl-wrapper) module.

### GKE Clusters with stub_domains or upstream_nameservers enabled

- This is a no-op change as there is no destroy command.

### ACM/ConfigSync module

- This is destructive and will result in the destruction and reapplication of the CRDs and manifests.
- If the destroy hook for deleting the Kubernetes secret `git-creds` results in an error during the upgrade process, manual removal will be needed to successfully complete the upgrade.
- The default value for `skip_gcloud_download` for these modules have been changed to `true`. If you would like to continue using `skip_gcloud_download = false` you can override the default value.

```diff
module "acm" {
   source               = "terraform-google-modules/kubernetes-engine/google//modules/acm"
-  version              = "~> 10.0"
+  version              = "~> 11.0"
+  skip_gcloud_download = false
}
```

### ASM module

- This is destructive and will result in the destruction and reapplication of the CRDs and manifests.
- This will also result in the destruction and recreation of the GKE Hub membership.
- The variable `use_tf_google_credentials_env_var` is no longer surfaced.

```diff
module "asm" {
   source                            = "terraform-google-modules/kubernetes-engine/google//modules/asm"
+  version                           = "~> 11.0"
-  version                           = "~> 10.0"
-  use_tf_google_credentials_env_var = true
}
```

### Workload Identity

- Use of Workload Identity module without `use_existing_k8s_sa` enabled is no-op as it does not trigger the annotation of existing KSA.
- Use of Workload Identity module with `use_existing_k8s_sa` enabled is no-op due to usage of `--overwrite` flag while annotating KSA.
