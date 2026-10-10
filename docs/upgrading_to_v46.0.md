# Upgrading to v46.0

The v46.0 release of *kubernetes-engine* is a backwards incompatible release.

## Migration Guide

### Google Cloud Platform Provider upgrade

This release adds support for version 8 (`< 9`) of the Google Cloud Platform Providers (`hashicorp/google` and `hashicorp/google-beta`) across all modules, and updates the minimum required provider versions for several sub-modules:

- **Beta Autopilot Cluster Modules** (`beta-autopilot-private-cluster`, `beta-autopilot-public-cluster`): Minimum required version of `google` and `google-beta` increased from `>= 7.17.0` to `>= 7.28.0`.
- **`gke-autopilot-cluster`**: Minimum required version of `google-beta` increased from `>= 6.33.0` to `>= 7.9.0`.
- **`gke-standard-cluster` and `gke-node-pool`**: Minimum required version of `google-beta` increased from `>= 6.33.0` to `>= 7.39.0`.
- **`auth`, `binary-authorization`, and `hub-legacy`**: Minimum required version of `google` (and `google-beta` where applicable) increased to `>= 5.0.0`.
