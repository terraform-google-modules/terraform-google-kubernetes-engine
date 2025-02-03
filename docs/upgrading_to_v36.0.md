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

### ASM Sub-Module Removal
The ASM Sub-Module has been removed in v36.0.  Please use the [google_gke_hub_feature](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature#example-usage---enable-fleet-default-member-config-service-mesh) and [google_gke_hub_feature_membership](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#example-usage---service-mesh) resources.  For another example, see [terraform-docs-samples/gke/autopilot
/mesh](https://github.com/terraform-google-modules/terraform-docs-samples/tree/main/gke/autopilot/basic).


```diff
-module "asm" {
-  source  = "terraform-google-modules/kubernetes-engine/google//modules/asm"
-  version = "~> 35.0"

-  project_id                = var.project_id
-  cluster_name              = module.gke.name
-  cluster_location          = module.gke.location
-  multicluster_mode         = "connected"
-  enable_cni                = true
-  enable_fleet_registration = true
-  enable_mesh_feature       = true
-}

+resource "google_gke_hub_feature" "mesh_feature" {
+  project  = var.project_id
+  location = "global"
+  name     = "servicemesh"
+}

+resource "google_gke_hub_feature_membership" "mesh_feature_membership" {
+  project  = var.project_id
+  location = "global"

+  feature             = google_gke_hub_feature.mesh_feature.name
+  membership          = module.gke.fleet_membership
+  membership_location = module.gke.region

+  mesh {
+    management = "MANAGEMENT_AUTOMATIC"
+  }
+}
```
