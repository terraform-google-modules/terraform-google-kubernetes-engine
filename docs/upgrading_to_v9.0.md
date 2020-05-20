# Upgrading to v9.0

The v9.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Provider Version

- Support for Google provider versions older than v3.19 has been removed due to the introduction of GKE metering block support and CE PD CSI Driver features.

## Beta Clusters

Beta clusters now defaults `node_metadata` to `GKE_METADATA_SERVER` for enabling Workload Identity by default.

If you would like to continue using `SECURE` you can override the default value.

```diff
module "gke" {
    source        = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
-   version       = "~> 8.0"
+   version       = "~> 9.0"
...
+   node_metadata = "SECURE"
}
```

## ACM Module

The ACM module has been refactored and resources will be recreated; particularly note the recreation of `tls_private_key` if `create_ssh_key` is enabled.

```diff
- module.acm.tls_private_key.git_creds[0]
+ module.acm.module.acm_operator.tls_private_key.k8sop_creds[0]
```

## Safer Cluster Module

For the Safer Cluster module, you must now specify `release_channel` instead of `kubernetes_version`.
The `release_channel` can be chosen based on type of workload. For production workloads `REGULAR` is recommended or `STABLE` if stability is paramount.

More information about release channels can be found [here](https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels).

Release notes for each release channel can be found [here](https://cloud.google.com/kubernetes-engine/docs/release-notes).
