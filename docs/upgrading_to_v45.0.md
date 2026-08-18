# Upgrading to v45.0
The v45.0 release of *kubernetes-engine* is a backwards incompatible release.

## Migration Guide

### `kubernetes_config_map` replaced by `kubernetes_config_map_v1`

The `ip-masq-agent` ConfigMap resource has been migrated from `kubernetes_config_map` to `kubernetes_config_map_v1` to address a deprecation warning introduced in the Kubernetes provider v7.15.0.

Terraform's `moved` block does not support changing the resource type, so users with `configure_ip_masq = true` must manually migrate the resource in state to avoid recreation. Run the following command, adjusting the module path to match your configuration:

```
terraform state mv \
  'module.gke.kubernetes_config_map.ip_masq_agent[0]' \
  'module.gke.kubernetes_config_map_v1.ip_masq_agent[0]'
```

> [!NOTE]
> The full resource address depends on how you reference the module and may include the index (`[0]`) since the resource uses `count`. Run `terraform state list | grep ip_masq_agent` to confirm the exact source address before running the `state mv` command.

If the state is not migrated, Terraform will plan to destroy the existing `kubernetes_config_map.ip_masq_agent` resource and create a new `kubernetes_config_map_v1.ip_masq_agent` resource.
