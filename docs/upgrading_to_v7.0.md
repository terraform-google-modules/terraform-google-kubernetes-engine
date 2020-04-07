# Upgrading to v7.0

The v7.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Provider Version
Support for Google provider versions older than v3.1 has been removed due to the introduction of Surge Upgrade features.

## Surge Upgrades (beta)
In order to support [Surge Upgrades](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-upgrades#surge) on beta clusters, an `upgrade_settings` block has been added to all node pools. This will show up in `terraform plan`:

```
      + upgrade_settings {
          + max_surge       = 1
          + max_unavailable = 0
        }
```

The new default behavior will upgrade 1 node at a time. You can tune this behaviour using the new `max_surge` and `max_unavailable` settings on the node pool input.

Note that changing upgrade settings can be done in-place (without forcing a node pool recreation).

### Node Pool for_each
The `google_container_node_pool` resource has been updated to use `for_each` instead of `count`. This allows adding/removing node pools without causing a diff on unrelated node pools.

Updating to this new format requires running a state migration. Note that this migration **must** be run with **Terraform v0.12.20**. You can use a [script](../helpers/migrate7.py) we provided to automatically make the required state migration.

1. Download the script

    ```sh
    curl -O https://raw.githubusercontent.com/terraform-google-modules/terraform-google-kubernetes-engine/v7.0.0/helpers/migrate7.py
    chmod +x migrate7.py
    ```

2. Run the script in dryrun mode to confirm the expected changes:

    ```sh
    $ ./migrate7.py --dryrun

    ---- Migrating the following modules:
    -- module.gke-cluster-dev.module.gke
    ---- Commands to run:
    terraform state mv -state terraform.tfstate "module.gke-cluster-dev.module.gke.google_container_cluster.zonal_primary[0]" "module.gke-cluster-dev.module.gke.google_container_cluster.primary[0]"
    terraform state mv "module.gke-cluster-dev.module.gke.google_container_node_pool.zonal_pools[0]" "module.gke-cluster-dev.module.gke.google_container_node_pool.pools[0]"
    ```

3. Execute the migration script

    ```sh
    $ ./migrate7.py

    ---- Migrating the following modules:
    -- module.gke-cluster-dev.module.gke
    ---- Commands to run:
    Move "module.gke-cluster-dev.module.gke.google_container_cluster.zonal_primary[0]" to "module.gke-cluster-dev.module.gke.google_container_cluster.primary[0]"
    Successfully moved 1 object(s).
    Move "module.gke-cluster-dev.module.gke.google_container_node_pool.zonal_pools[0]" to "module.gke-cluster-dev.module.gke.google_container_node_pool.pools[0]"
    Successfully moved 1 object(s).
    Move "module.gke-cluster-dev.module.gke.null_resource.wait_for_zonal_cluster" to "module.gke-cluster-dev.module.gke.null_resource.wait_for_cluster"
    Successfully moved 1 object(s).
    ```

4. Run `terraform plan` to confirm no changes are expected.

## Null Resource Updates

As part of the upgrade, Terraform might indicate that the `wait_for_cluster` null_resource must be recreated.
This is a no-op which can be safely applied:

```
  # module.gke.null_resource.wait_for_cluster[0] must be replaced
-/+ resource "null_resource" "wait_for_cluster" {
      ~ id       = "8404887862418893500" -> (known after apply)
      + triggers = {
          + "name"       = "REDACTED"
          + "project_id" = "REDACTED"
        } # forces replacement
    }
```

Alternatively, if you run into changes with this update, you can remove the original resource from the state entirely:

```
terraform state rm module.gke.null_resource.wait_for_cluster
```
