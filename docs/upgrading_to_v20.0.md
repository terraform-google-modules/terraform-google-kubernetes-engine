# Upgrading to v20.0

The v20.0 release of *kubernetes-engine* is a backwards incompatible
release for the Anthos Service Mesh (ASM) module.

### ASM module rewrite

The [ASM submodule](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/asm) has been rewritten to use the `ControlPlaneRevision` API to provision
a managed control plane rather than using an installer script. Due to the drastic difference in implementation the module does not support an upgrade path
from the previous version.
