# Upgrading to v5.0

The v5.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Migration Instructions

### Node pool taints
Previously, node pool taints could be set on all module versions.

Now, to set taints you must use the beta version of the module.

```diff
 module "kubernetes_engine_private_cluster" {
-  source  = "terraform-google-modules/kubernetes-engine/google"
+  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
-  version = "~> 4.0"
+  version = "~> 5.0"
 }
```

### Service Account creation

Previously, if you explicitly specified a Service Account using the `service_account` variable on the module this was sufficient to force that Service Account to be used.

Now, an additional `create_service_account` has been added with a default value of `true`. If you would like to use an explicitly created Service Account from outside the module, you will need to set `create_service_account` to `false` (in addition to passing in the Service Account email).

No action is needed if you use the module's default service account.

```diff
 module "kubernetes_engine_private_cluster" {
   source  = "terraform-google-modules/kubernetes-engine/google"
-  version = "~> 4.0"
+  version = "~> 5.0"

   service_account        = "project-service-account@my-project.iam.gserviceaccount.com"
+  create_service_account = false
   # ...
 }
```

### Resource simplification
The `google_container_cluster` and `google_container_node_pool` resources previously were different between regional and zonal clusters. They have now been collapsed into a single resource using the `location` variable.

If you are using regional clusters, no migration is needed. If you are using zonal clusters, a state migration is needed. You can use a [script](../helpers/migrate.py) we provided to determine the required state changes:

1. Download the script

    ```
    curl -O https://raw.githubusercontent.com/terraform-google-modules/terraform-google-kubernetes-engine/v5.0.0/helpers/migrate.py
    chmod +x migrate.py
    ```

2. Execute the migration script

    ```
    ./migrate.py
    ```

    Output will be similar to the following:
    ```
    ---- Migrating the following modules:
    -- module.gke-cluster-dev.module.gke
    ---- Commands to run:
    terraform state mv -state terraform.tfstate "module.gke-cluster-dev.module.gke.google_container_cluster.zonal_primary[0]" "module.gke-cluster-dev.module.gke.google_container_cluster.primary[0]"
    terraform state mv "module.gke-cluster-dev.module.gke.google_container_node_pool.zonal_pools[0]" "module.gke-cluster-dev.module.gke.google_container_node_pool.pools[0]"
    ```

3. Execute the provided state migration commands (backups are automatically created).

4. Run `terraform plan` to confirm no changes are expected.
