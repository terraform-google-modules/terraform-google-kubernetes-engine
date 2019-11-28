# Upgrading to v6.0

The v6.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Dropped support
Due to changes in GKE, the module has dropped support for setting the `kubernetes_dashboard` variable.

Additionally, support for Google provider versions older than v2.18 has been removed.

## Migration Instructions

### Master Authorized Networks
Previously, setting up master authorized networks required setting a nested config within `master_authorized_networks_config`.
Now, to set up master authorized networks you can simply pass a list of authorized networks.

```diff
 module "kubernetes_engine_private_cluster" {
   source  = "terraform-google-modules/kubernetes-engine/google"
-  version = "~> 5.0"
+  version = "~> 6.0"

-  master_authorized_networks_config = [
+  master_authorized_networks = [
     {
-      cidr_blocks = [
-        {
-          cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
-          display_name = "VPC"
-        },
-      ]
+      cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
+      display_name = "VPC"
     },
   ]
 }
```
