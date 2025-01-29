# Upgrading to v36.0
The v36.0 release of *kubernetes-engine* is a backwards incompatible release.

### var.enable_gcfs removed from Autopilot
The variable `enable_gcfs` has been removed from the Autopilot sub-modules. Autopilot clusters that run GKE version `1.25.5-gke.1000` and later use Image streaming.

```diff
  module "cluster" {
-   version          = "~> 35.0"
+   version          = "~> 36.0"

-   enable_gcfs = true
}
```

### var.logging_variant removed from Autopilot
The variable `logging_variant` has been removed from the Autopilot sub-modules. It is only applicable to Standard clusters.

```diff
  module "cluster" {
-   version          = "~> 35.0"
+   version          = "~> 36.0"

-   logging_variant = "DEFAULT"
}
```
