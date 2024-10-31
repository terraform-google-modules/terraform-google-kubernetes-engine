# Upgrading to v35.0
The v35.0 release of *kubernetes-engine* is a backwards incompatible release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 6 of the Google Cloud Platform Providers.  See the [Terraform Google Provider 6.0.0 Upgrade Guide](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/version_6_upgrade) for more details.

### Private Cluster Sub-Modules Endpoint Output
The private cluster sub-modules now return the cluster's private endpoint for the `endpoint` output when the `enable_private_endpoint` argument is `true`, regardless of the `deploy_using_private_endpoint` argument value.

## Update variant random ID keepers updated

The v35.0 release updates the keepers for the update variant modules. This will force a recreation of the nodepools.

To avoid this, it is possible to edit the remote state of the `random_id` resource to add the new attributes.

1. Perform a `terraform plan` as normal, identifying the `random_id` resource(s) changing and the new/removed attributes
```tf
      ~ keepers     = { # forces replacement
          - "disk_type"                   = "" -> null
          - "disk_size_gb"                = "" -> null
          - "machine_type"                = "" -> null
          - "enable_gcfs"                 = "" -> null
            # (19 unchanged elements hidden)
        }
        # (2 unchanged attributes hidden)
    }
```
2. Pull the remote state locally: `terraform state pull > default.tfstate`
3. Back up the original remote state: `cp default.tfstate original.tfstate`
4. Edit the `random_id` resource(s) to add/remove the attributes from the `terraform plan` step
```diff
"attributes": {
            "b64_std": "pool-02-vb4=",
            "b64_url": "pool-02-vb4",
            "byte_length": 2,
            "dec": "pool-02-48574",
            "hex": "pool-02-bdbe",
            "id": "vb4",
            "keepers": {
            ...
              "taints": "",
-             "disk_size_gb": "",
-             "enable_gcfs": "",
-             "machine_type": "",
-             "disk_type": "",
            },
            "prefix": "pool-02-"
          }
```
1. Bump the serial number at the top
2. Push the modified state to the remote `terraform state push default.tfstate`
3. Confirm the `random_id` resource(s) no longer changes (or the corresponding `nodepool`) in a `terraform plan`

### ASM Sub-Module Removal
The ASM Sub-Module has been removed in v35.0.  Please use the [google_gke_hub_feature](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature#example-usage---enable-fleet-default-member-config-service-mesh) and [google_gke_hub_feature_membership](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_feature_membership#example-usage---service-mesh) resources.


```diff
-module "asm" {
-  source  = "terraform-google-modules/kubernetes-engine/google//modules/asm"
-  version = "~> 34.0"

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
