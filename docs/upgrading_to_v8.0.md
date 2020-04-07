# Upgrading to v8.0

The v8.0 release of *kubernetes-engine* is a backwards incompatible
release.

## default_max_pods_per_node supported in all modules
All modules variants now support [default_max_pods_per_node](https://www.terraform.io/docs/providers/google/r/container_cluster.html#default_max_pods_per_node). Defaults to `110`.

## Workload Identity (beta)
Beta clusters now have Workload Identity enabled by default. To disable Workload Identity, set `identity_namespace = null`

## Shielded Nodes (beta)
Beta clusters now have shielded nodes enabled by default. To disable, set `enable_shielded_nodes = false`

## Autoscaling_Profile (beta)
Beta clusters now have support for [autoscaling_profile](https://www.terraform.io/docs/providers/google/r/container_cluster.html#autoscaling_profile). Defaults to `BALANCED`

```
      + cluster_autoscaling {
          + autoscaling_profile       = "OPTIMIZE_UTILIZATION"
        }
```
## Support for Istio Auth (beta)
Beta clusters now have support for [istio_auth](https://www.terraform.io/docs/providers/google/r/container_cluster.html#auth). Defaults to `AUTH_MUTUAL_TLS`
