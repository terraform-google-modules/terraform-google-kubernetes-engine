# Upgrading to v16.0

The v16.0 release of *kubernetes-engine* is a backwards incompatible release.

### cluster_autoscaling modified
The `cluster_autoscaling` variable has been modified to require a `gpu_resources` value. If you have enabled `cluster_autoscaling` and do not require `gpu_resources`, you can set it to an empty list as shown below.

```diff
 module "gke" {
   source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
-  version = "~> 15.0"
+  version = "~> 16.0"

  cluster_autoscaling = {
    enabled             = true
    autoscaling_profile = "BALANCED"
    min_cpu_cores       = 1
    max_cpu_cores       = 100
    min_memory_gb       = 1
    max_memory_gb       = 1000
+   gpu_resources = []
  }
}
```
