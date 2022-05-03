# Upgrading to v21.0
The v21.0 release of *kubernetes-engine* is a backwards incompatible
release.

### Terraform Kubernetes Engine Module

The [Terraform Kubernetes Engine Module](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine) has been rewritten to use the 'kubernetes_config_map_v1_data' resouce added to the Terraform Kubernetes provider version 2.10.

1. Run `terraform state rm module.gke.kubernetes_config_map.kube-dns`
2. Update the module version to v21.0
4. Run `terraform apply`

### Kubernetes Provider upgrade
The Terraform Kubernetes Engine module now requires version 2.10 or higher of
the Kubernetes Provider.

### Hub module rewrite
The old [Hub submodule](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v20.0.0/modules/hub)
has been renamed to `hub-legacy` and deprecated. It is replaced with a new [fleet membership](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/fleet-membership)
module to handle registering GKE clusters to [fleets](https://cloud.google.com/anthos/multicluster-management/fleets) using the native API.

The new module relies exclusively on native Terraform resources and should therefore be more robust.

### Migrating
For GKE clusters, you should update your configuration as follows:

```diff
  module "register" {
-   source           = "terraform-google-modules/kubernetes-engine/google//modules/hub"
-   version          = "~> 20.0"
+   source           = "terraform-google-modules/kubernetes-engine/google//modules/fleet-membership"
+   version          = "~> 21.0"

    project_id       = "my-project-id"
    cluster_name     = "my-cluster-name"
-   gke_hub_membership_name = "gke-membership"
+   membership_name  = "gke-hub-membership"
    location         = module.gke.location
-   cluster_endpoint = module.gke.endpoint
-   gke_hub_sa_name         = "sa-for-kind-cluster-membership"
-   use_kubeconfig          = true
-   labels                  = "testlabel=usekubecontext"
-   module_depends_on       = [module.gke]
}
```

You also need to follow these migration steps:

1. Remove the old module from your state:

    ```
    terraform state rm module.register
    ```

2. Remove the cluster from the fleet:

    ```
    gcloud container fleet memberships delete gke-hub-membership-name
    ```

3. Apply the new configuration to re-register the cluster:

    ```
    terraform apply
    ```

#### Legacy module
**The native API only supports registering GKE clusters**. Therefore, the old hub module is preserved as `hub-legacy`.

You can continue using it by updating your configuration to point to the new location.

```diff
  module "register" {
-   source           = "terraform-google-modules/kubernetes-engine/google//modules/hub"
-   version          = "~> 20.0"
+   source           = "terraform-google-modules/kubernetes-engine/google//modules/hub-legacy"
+   version          = "~> 21.0"

    project_id       = "my-project-id"
    cluster_name     = "my-cluster-name"
    location         = module.gke.location
    cluster_endpoint = module.gke.endpoint
  }
```

### Anthos Config Management (ACM) and Config Sync Module Rewrite
Together with the rewrite of the Hub module, the ACM module also has been rewritten to use native resources.

You will need to follow these migration steps:

1. Update your configuration to use the new module:

    ```diff
      module "acm" {
        source           = "terraform-google-modules/kubernetes-engine/google//modules/acm"
    -   version          = "~> 20.0"
    +   version          = "~> 21.0"

        project_id      = "my-project-id"
        cluster_name    = "simple-zonal-cluster"
        location        = "us-central1-a"
    -   cluster_endpoint = module.auth.host

        sync_repo   = "git@github.com:GoogleCloudPlatform/csp-config-management.git"
        sync_branch = "1.0.0"
        policy_dir  = "foo-corp"

        secret_type = "ssh"
      }
    ```

1. Make sure you have the `kubernetes` provider configured:

    ```hcl
    provider "kubernetes" {
      cluster_ca_certificate = module.auth.cluster_ca_certificate
      host                   = module.auth.host
      token                  = module.auth.token
    }
    ```

1. Remove the old module from your state:

    ```
    terraform state rm module.acm
    ```

2. Import the old `git-creds` secret into Terraform:

    ```
    terraform import 'module.acm.module.acm_operator.kubernetes_secret_v1.creds' 'config-management-system/git-creds'
    ```

3. Apply the new configuration to re-register ACM and confirm everything is working:

    ```
    terraform apply
    ```

#### Feature Activation

Only the first cluster in a fleet should activate the ACM fleet feature.
Other clusters should disable feature activation by setting `enable_fleet_feature = false`.

#### Config Sync Module Removed
The dedicated Config Sync submodule has been removed.
To use Config Sync, just invoke the ACM module with `enable_policy_controller = false`.
