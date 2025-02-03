# Upgrading to v36.0
The v36.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 6.14 or higher of the Google Cloud Platform Providers.

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

### ACM Sub-Module Removal
The ACM Sub-Module has been removed in v36.0.  Please use the [google_gke_hub_feature](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature#example-usage---enable-fleet-default-member-config-configmanagement) and [google_gke_hub_feature_membership](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#example-usage---config-management-with-git) resources.  For additional examples, see [terraform-docs-samples/gke/autopilot/config_sync](https://github.com/terraform-google-modules/terraform-docs-samples/tree/main/gke/autopilot/config_sync) and [terraform-docs-samples/gke/autopilot/policycontroller](https://github.com/terraform-google-modules/terraform-docs-samples/tree/main/gke/autopilot/policycontroller).


```diff
-module "acm" {
-  source  = "terraform-google-modules/kubernetes-engine/google//modules/acm"
-  version = "~> 35.0"
-  project_id   = var.project_id
-  location     = module.gke.location
-  cluster_name = module.gke.name

-  # Config Sync
-  enable_config_sync = true
-  sync_repo   = "git@github.com:GoogleCloudPlatform/anthos-config-management-samples.git"
-  sync_branch = "main"
-  policy_dir  = "foo-corp"

-  # Policy Controller
-  enable_policy_controller = true
-  enable_fleet_feature = true
-  install_template_library = true
-  enable_referential_rules = true
-  policy_bundles = ["https://github.com/GoogleCloudPlatform/acm-policy-controller-library.git/bundles/pss-baseline-v2022"]
-}

# Config Sync
+resource "google_gke_hub_feature" "config_feature" {
+  project  = var.project_id
+  location = "global"
+  name     = "configmanagement"
+}

+resource "google_gke_hub_feature_membership" "config_feature_membership" {
+  project  = var.project_id
+  location = "global"

+  feature             = google_gke_hub_feature.config_feature.name
+  membership          = module.gke.fleet_membership
+  membership_location = module.gke.region

+  configmanagement {
+    config_sync {
+      enabled = true
+      git {
+        sync_repo = "git@github.com:GoogleCloudPlatform/anthos-config-management-samples.git"
+        sync_branch = "main"
+        policy_dir = "foo-corp"
+      }
+    }
+  }
+}

# Policy Controller
+resource "google_gke_hub_feature" "poco_feature" {
+  project  = var.project_id
+  location = "global"
+  name     = "policycontroller"
+}
+
+resource "google_gke_hub_feature_membership" "poco_feature_membership" {
+  project  = var.project_id
+  location = "global"
+
+  feature             = google_gke_hub_feature.poco_feature.name
+  membership          = module.gke.fleet_membership
+  membership_location = module.gke.region
+
+  policycontroller {
+    policy_controller_hub_config {
+      install_spec = "INSTALL_SPEC_ENABLED"
+      policy_content {
+        template_library {
+          installation = "ALL"
+        }
+        bundles {
+          bundle_name = "pss-baseline-v2022"
+        }
+      }
+      referential_rules_enabled = true
+    }
+  }
+}
```

### ASM Sub-Module Removal
The ASM Sub-Module has been removed in v36.0.  Please use the [google_gke_hub_feature](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature#example-usage---enable-fleet-default-member-config-service-mesh) and [google_gke_hub_feature_membership](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#example-usage---service-mesh) resources.  For another example, see [terraform-docs-samples/gke/autopilot
/mesh](https://github.com/terraform-google-modules/terraform-docs-samples/tree/main/gke/autopilot/mesh).


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
