# Upgrading to v33.0
The v33.0 release of *kubernetes-engine* is a backwards incompatible release.

### Private Cluster Defaults
All private-cluster modules now set `enable_private_nodes` to `true` by default.
To opt out, set `enable_private_nodes` to `false`.

```diff
  module "cluster" {
-   version          = "~> 32.0"
+   version          = "~> 33.0"

+   enable_private_nodes = false
}
```

### Autopilot Cluster GCFS Default
Autopilot cluster modules now set `enable_gcfs` to `true` by default to
aligned with TPGv6. To maintain the previous provider default behavior, set
`enable_gcfs` to `null`.

```diff
  module "cluster" {
-   version          = "~> 32.0"
+   version          = "~> 33.0"

+   enable_gcfs = null
}
```

### Advanced Datapath Observability Relay
The `monitoring_observability_metrics_relay_mode` parameter has been
replaced with `monitoring_enable_observability_relay`.

```diff
  module "cluster" {
-   version          = "~> 32.0"
+   version          = "~> 33.0"

-   monitoring_observability_metrics_relay_mode = "INTERNAL_VPC_LB"
+   monitoring_enable_observability_relay       = true
}
```
