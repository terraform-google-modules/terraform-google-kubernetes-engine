# Upgrading to v8.0

The v8.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Workload Identity (beta)
Beta clusters now have Workload Identity enabled by default. To disable Workload Identity, set `identity_namespace = null`

## Shielded Nodes (beta)
Beta clusters now have shielded nodes enabled by default. To disable, set `enable_shielded_nodes = false`
