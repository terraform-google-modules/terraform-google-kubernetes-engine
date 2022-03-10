# Upgrading to v20.0

The v20.0 release of *kubernetes-engine* is a backwards incompatible
release for the Anthos Service Mesh (ASM) module.

### ASM module rewrite

The [ASM submodule](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/asm) has been rewritten to use the `ControlPlaneRevision` API to provision
a managed control plane rather than using an installer script. Due to implementation differences, there are migration steps required to safely move from
an installation performed with the old module to using the new module. **NOTE:** these migration steps are best-effort and have not been tested against all possible ASM configurations.

1. Run `terraform state rm module.asm`
2. Update the module version to v20.0
3. Import the system namespace into the new module with `terraform import module.asm.kubernetes_namespace.system istio-system`
4. Run `terraform apply`

There should be two ASM revisions present at this point (in-cluster or managed, depending on whether the previous installation was managed). Now,
we must perform a canary upgrade to move workloads onto the new ASM revision. To do this:

1. Relabel namespaces to use the revision label from the managed revision (`asm-managed`, `asm-managed-stable`, or `asm-managed-rapid`)
2. Rollout workloads in those namespaces to get them onto the new ASM version
3. [Optional] Remove the previous revision with `istioctl x uninstall --revision ...` (if the previous installation was in-cluster)


#### Migrating options

Another difference from the previous module is that the new ASM module does not provide variables for option configuration (e.g. `custom_overlay`, `options`). For the new version these should be managed separately
outside the module. This is because those options were tightly coupled to pulling down an installer which the new module does not do. To use options specified in the previous module with the new module find the corresponding configuration [here](https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages/tree/main/asm/istio/options) and move the
config to the mesh configuration for the managed revision.

### Google Cloud Platform Provider upgrade
The Terraform Kubernetes Engine Module now requires version 4.10 or higher of
the Google Cloud Platform Provider and 4.10 or higher of
the Google Cloud Platform Beta Provider.
