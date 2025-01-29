# Upgrading to v36.0
The v36.0 release of *kubernetes-engine* is a backwards incompatible release.

### var.enable_gcfs removed from Autopilot sub-modules
The variable `enable_gcfs` has been removed from the Autopilot sub-modules. Autopilot clusters that run GKE version `1.25.5-gke.1000` and later use [Image streaming](https://cloud.google.com/kubernetes-engine/docs/how-to/image-streaming).

```diff
  module "cluster" {
-   version          = "~> 35.0"
+   version          = "~> 36.0"

-   enable_gcfs = true
}
```

### var.logging_variant removed from Autopilot sub-modules
The variable `logging_variant` has been removed from the Autopilot sub-modules. It is only [applicable](https://cloud.google.com/kubernetes-engine/docs/how-to/adjust-log-throughput) to Standard clusters.

```diff
  module "cluster" {
-   version          = "~> 35.0"
+   version          = "~> 36.0"

-   logging_variant = "DEFAULT"
}
```
