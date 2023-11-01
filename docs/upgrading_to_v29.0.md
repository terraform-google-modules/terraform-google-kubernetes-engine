# Upgrading to v29.0
The v29.0 release of *kubernetes-engine* is a backwards incompatible
release.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 5.0 or higher of the Google Cloud Platform Providers.

```diff
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
-      version = "~> 4.0"
+      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
-      version = "~> 4.0"
+      version = "~> 5.0"
    }

  }
}
```

### Deletion Protection
The Terraform Kubernetes Engine Module now includes the `deletion_protection` option which defaults to `true`.  To delete your cluster you should specify it explicitly to `false`:

```diff
  module "gke" {
-   source  = "terraform-google-modules/kubernetes-engine/google"
-   version = "~> 28.0"
+   source  = "terraform-google-modules/kubernetes-engine/google"
+   version = "~> 29.0"
...
+   deletion_protection = false
}
```

### Update variant random ID keepers updated

The v29.0 release updates the keepers for the update variant modules. This will force a recreation of the nodepools.

To avoid this, it is possible to edit the remote state of the `random_id` resource to add the new attributes.

1. Perform a `terraform plan` as normal, identifying the `random_id` resource(s) changing and the new/removed attributes
```tf
      ~ keepers     = { # forces replacement
          + "boot_disk_kms_key"           = ""
          + "gpu_partition_size"          = ""
          - "labels"                      = "" -> null
          + "placement_policy"            = ""
          - "tags"                        = "" -> null
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
-             "labels": "",
-             "tags": "",
+             "boot_disk_kms_key": "",
+             "gpu_partition_size": "",
+             "placement_policy": "",
            },
            "prefix": "pool-02-"
          }
```
1. Bump the serial number at the top
2. Push the modified state to the remote `terraform state push default.tfstate`
3. Confirm the `random_id` resource(s) no longer changes (or the corresponding `nodepool`) in a `terraform plan`

### Default cluster service account permissions modified

When `create_service_account` is `true`, the service account will now be created with `Kubernetes Engine Node Service Account` role instead of `Logs Writer`, `Monitoring Metric Writer`, `Monitoring Viewer` and `Stackdriver Resource Metadata Writer` roles.
This is the Google recommended least privileged role to be used for the service account attached to the GKE Nodes.
