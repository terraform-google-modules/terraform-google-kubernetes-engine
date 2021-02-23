# Upgrading to v14.0

The v14.0 release of *kubernetes-engine* is a backwards incompatible
release for some versions of Anthos Service Mesh (ASM).

It uses the new ASM [installation script](https://cloud.google.com/service-mesh/docs/scripted-install/asm-onboarding) which:
- Does not support installation and upgrades for ASM versions older than 1.7.3.
- Supports upgrades from versions 1.7.3+ or a 1.8 patch release.
- Supports migrations from opern source Istio 1.7 or 1.8 to Anthos Service Mesh

Please see the script page for up to date details.

### ASM default version changed to 1.8

[ASM submodule](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/asm) has been changed to use ASM v1.8 as default.

```diff
variable "asm_version" {
  description = "ASM version to deploy. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages"
  type        = string
+  default     = "1.8"
-  default     = "release-1.6-asm"
}
```
