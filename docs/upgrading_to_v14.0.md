# Upgrading to v14.0

The v14.0 release of *kubernetes-engine* is a backwards incompatible
release for some versions of Anthos Service Mesh (ASM).

### ASM default version changed to 1.8

[ASM submodule](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/asm) has been changed to use ASM v1.8 as default.

The module now uses the new ASM [installation script](https://cloud.google.com/service-mesh/docs/scripted-install/asm-onboarding) which:
- Does not support installation and upgrades for ASM versions older than 1.7.3.
- Supports upgrades only from versions 1.7.3+ or a 1.8 patch release.
- Supports migrations from open source Istio 1.7 or 1.8 to ASM

Please see the script page for up to date details.
