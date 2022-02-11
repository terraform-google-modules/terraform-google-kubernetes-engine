# Terraform Kubernetes Engine ASM Submodule

This module installs [Anthos Service Mesh](https://cloud.google.com/service-mesh/docs) (ASM) in a Kubernetes Engine (GKE) cluster.

## Usage

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| channel | The channel to use for this ASM installation. | `string` | `""` | no |
| cluster\_location | The cluster location for this ASM installation. | `string` | n/a | yes |
| cluster\_name | The unique name to identify the cluster in ASM. | `string` | n/a | yes |
| enable\_cni | Determines whether to enable CNI for this ASM installation. | `bool` | `false` | no |
| enable\_cross\_cluster\_service\_discovery | Determines whether to enable cross-cluster service discovery between this cluster and other clusters in the fleet. | `bool` | `false` | no |
| enable\_mdp | Determines whether to enable Managed Data Plane (MDP) for this ASM installation. | `bool` | `false` | no |
| mesh\_config | MeshConfig specifies configuration available to the control plane. If unset the module will not attempt to create the MeshConfig (i.e. if managing this configuration elsewhere). The full list of options can be found at https://istio.io/latest/docs/reference/config/istio.mesh.v1alpha1/#MeshConfig | `map(any)` | `{}` | no |
| project\_id | The project in which the resource belongs. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| revision\_name | The name of the installed managed ASM revision. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
