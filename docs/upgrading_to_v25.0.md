# Upgrading to v25.0
The v25.0 release of *kubernetes-engine* is a backwards incompatible
release.

### gce_pd_csi_driver is GA and enabled by default

`gce_pd_csi_driver` is now supported in GA modules and defaults to true. To opt out, set `gce_pd_csi_driver` to `false`.

```diff
  module "gke" {
-   source           = "terraform-google-modules/kubernetes-engine"
-   version          = "~> 24.0"
+   source           = "terraform-google-modules/kubernetes-engine"
+   version          = "~> 25.0"
...
+   gce_pd_csi_driver  = false
}
```

### Use the created service account when creating autopilot clusters

When `create_service_account` is `true` pass the created service account to the `cluster_autoscaling` -> `auto_provisioning_defaults` block
for the `beta-autopilot-private-cluster` / `beta-autopilot-public-cluster` modules.

This will mean that the `Nodes` will use the created service account, where previously the default service account was erronously used instead.

To opt out, set `create_service_account` to `false`

```diff
  module "gke" {
-   source           = "terraform-google-modules/kubernetes-engine"
-   version          = "~> 24.0"
+   source           = "terraform-google-modules/kubernetes-engine"
+   version          = "~> 25.0"
...
+   create_service_account  = false
}
```

### Minimum Google Provider versions

Minimum Google Provider versions have been updated to `4.51.0`.
