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

### Update variant random ID keepers updated

The `*-update-variant` modules (`private-cluster-update-variant`, `beta-private-cluster-update-variant`, `beta-public-cluster-update-variant`) have added `"subnetwork"` to `force_node_pool_recreation_resources`. Because `network_config.subnetwork` is a `ForceNew` field on `google_container_node_pool`, this keeper is required so that `create_before_destroy` can produce a clean replacement when a pool's subnet changes.

However, adding any key to the `random_id.name` keepers causes the id to roll for **all** node pools in those modules, forcing recreation even for pools that do not use `subnetwork`. This matches the behaviour documented in the [v29.0 upgrade guide](upgrading_to_v29.0.md).

To avoid recreation, edit the `random_id` keeper state after upgrading:

1. Perform a `terraform plan` to identify the `random_id` resources changing:
```tf
      ~ keepers     = { # forces replacement
          + "subnetwork"  = ""
            # (N unchanged elements hidden)
        }
```
2. Pull the remote state: `terraform state pull > default.tfstate`
3. Back up: `cp default.tfstate original.tfstate`
4. Add the new key to each `random_id` resource in the state:
```diff
"keepers": {
  ...
+ "subnetwork": "",
},
```
5. Bump the `serial` number at the top of the file.
6. Push: `terraform state push default.tfstate`
7. Confirm `terraform plan` no longer shows the `random_id` (or the corresponding node pool) as changing.
