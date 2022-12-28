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

### Minimum Google Provider versions

Minimum Google Provider versions have been updated to `4.44.0`.
