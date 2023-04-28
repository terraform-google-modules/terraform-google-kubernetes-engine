# Upgrading to v26.0
The v26.0 release of *kubernetes-engine* is a backwards incompatible
release.

### release_channel now defaults to REGULAR

For all clusters `release_channel` now defaults to `REGULAR`, this was already
the default for safer_cluster variants.

To opt out of using a release channel, set `release_channel` to `"UNSPECIFIED"`.

```diff
  module "gke" {
-   source           = "terraform-google-modules/kubernetes-engine"
-   version          = "~> 25.0"
+   source           = "terraform-google-modules/kubernetes-engine"
+   version          = "~> 26.0"
...
+   release_channel = "UNSPECIFIED"
}
```
