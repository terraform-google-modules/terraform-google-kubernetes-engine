# Upgrading to v9.0

The v9.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Provider Version

- Support for Google provider versions older than v3.16 has been removed due to the introduction of GKE metering block.
- Support for Google-Beta provider versions older than v3.19 has been removed due to the introduction of GCE PD CSI Driver features.

## ACM Module

The ACM module has been refactored and resources will be recreated. This will show up in Terraform plans but is a safe no-op for Kubernetes.

## Safer Cluster Module

For the Safer Cluster module, you must now specify `release_channel` instead of `kubernetes_version`.