# Upgrading to v36.0

The v36.0 release of _kubernetes-engine_ is a backwards incompatible release.

### master_authorized_networks default value

The default value for `master_authorized_networks` has been changed from `[]` to `null`. To maintain the previous default behavior, set `master_authorized_networks` to `[]`. This change is because the API interprets an existing `master_authorized_networks_config` to enable authorized networks, but we want to be explicit about enabling this option.

```
  module "gke" {
    source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
    version = "~> 36.0"

    project_id  = var.project_id
    name        = var.cluster_name

+   master_authorized_networks = []
  }
```
