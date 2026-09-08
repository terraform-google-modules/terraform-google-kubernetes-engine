# Upgrading to v45.0

The v45.0 release of *kubernetes-engine* is a backwards incompatible release.

## Migration Guide

### `kubernetes_config_map` replaced with `kubernetes_config_map_v1` for ip-masq-agent

The deprecated `kubernetes_config_map` resource has been replaced with `kubernetes_config_map_v1` for the ip-masq-agent ConfigMap ([#2627](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/2627)).

The `hashicorp/kubernetes` provider does not implement `MoveResourceState` for this resource type, so automatic state migration via `moved` blocks is not possible. Users with `configure_ip_masq = true` must migrate state manually after upgrading:

```bash
terraform state pull > state.json
jq '.resources |= map(if .type == "kubernetes_config_map" and (.instances[].attributes.metadata[0].name == "ip-masq-agent") then .type = "kubernetes_config_map_v1" else . end) | .serial += 1' state.json > state.new.json
terraform state push state.new.json
```

Alternatively, the ConfigMap holds no persistent data and can safely be allowed to be recreated (`terraform apply` will destroy and recreate it).
