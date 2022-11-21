# Upgrading to v24.0
The v24.0 release of *kubernetes-engine* is a backwards incompatible
release.

### master_global_access_enabled in GA private-cluster module

`master_global_access` is now supported in GA private-cluster module and defaults to true. To opt out, set `master_global_access_enabled` to `false`.

```diff
  module "gke" {
-   source           = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
-   version          = "~> 23.0"
+   source           = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
+   version          = "~> 24.0"
...
+   master_global_access_enabled  = false
}
```

### Update variant random ID keepers updated

The v24.0 release updates the keepers for the update variant modules. This will force a recreation of the nodepools.

To avoid this, it is possible to edit the remote state of the `random_id` resource to add the new attributes.

1. Perform a `terraform plan` as normal, identifying the `random_id` resources changing and the new `max_pods_per_node` and `pod_range` attributes
```tf
      ~ keepers     = { # forces replacement
          + "max_pods_per_node"           = ""
          + "pod_range"                   = ""
            # (19 unchanged elements hidden)
        }
        # (2 unchanged attributes hidden)
    }
```
2. Pull the remote state locally: `terraform state pull > default.tfstate`
1. Back up the original remote state: `cp default.tfstate original.tfstate`
1. Edit the `random_id` resources to add in the new `max_pods_per_node` and `pod_range` attributes from the `terraform plan` step
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
+             "max_pods_per_node": "",
+             "pod_range": ""
            },
            "prefix": "pool-02-"
          }
```
5. Bump the serial number at the top
1. Push the modified state to the remote `terraform state push default.tfstate`
1. Confirm the `random_id` resource no longer changes (or the corresponding `nodepool`) in a `terraform plan`

### Minimum Google Provider versions

Minimum Google Provider versions have been updated to `4.42.0`.
