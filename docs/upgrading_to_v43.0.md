# Upgrading to v43.0
The v43.0 release of *kubernetes-engine* is a backwards incompatible release.

## Migration Guide

### `kalm_config` Removal

The `kalm_config` variable has been removed.

Users currently including `kalm_config` should remove this variable from their module definition.

### `istio_config` Removal

The `istio` and `istio_auth` variables have been removed.  The `istio_enabled` output has also been removed from these modules and the autopilot beta modules.

Users currently using the GKE Istio addon should migrate to Anthos Service Mesh (ASM) or another service mesh solution.
