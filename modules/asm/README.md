# Terraform Kubernetes Engine ASM Submodule

This module installs [Anthos Service Mesh](https://cloud.google.com/service-mesh/docs) (ASM) in a Kubernetes Engine (GKE) cluster.

Specifically, this module automates installing the ASM Istio Operator on your cluster ([installing ASM](https://cloud.google.com/service-mesh/docs/install)).

## Usage

There is a [full example](../../examples/simple_zonal_with_asm) provided. Detailed usage example is as follows:

```tf
module "asm" {
  source                = "terraform-google-modules/kubernetes-engine/google//modules/asm"

  project_id            = "my-project-id"
  cluster_name          = "my-cluster-name"
  location              = module.gke.location
  cluster_endpoint      = module.gke.endpoint
  enable_all            = false
  enable_cluster_roles  = true
  enable_cluster_labels = false
  enable_gcp_apis       = false
  enable_gcp_iam_roles  = true
  enable_gcp_components = true
  enable_registration   = false
  managed_control_plane = false
  options               = ["envoy-access-log,egressgateways"]
  custom_overlays       = ["./custom_ingress_gateway.yaml"]
  skip_validation       = true
  outdir                = "./${module.gke.name}-outdir-${var.asm_version}"
}
```

To deploy this config:

1. Run `terraform apply`

## Requirements

- Anthos Service Mesh on GCP no longer requires an active Anthos license. You can use Anthos Service Mesh as a standalone product on GCP (on GKE) or as part of your Anthos subscription for hybrid and multi-cloud architectures.
- GKE cluster must have minimum four nodes.
- Minimum machine type is `e2-standard-4`.
- GKE cluster must be enrolled in a release channel. ASM does not support static version.
- ASM on a private GKE cluster requires adding a firewall rule to open port 15017 if you want to use [automatic sidecar injection](https://cloud.google.com/service-mesh/docs/proxy-injection).
- One ASM mesh per Google Cloud project is supported.

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| asm\_git\_tag | ASM git tag to deploy. This module supports versions `1.8`, `1.9` and `1.10`. You can get the exact `asm_git_tag` by running the command `install_asm --version`. The ASM git tab should be of the form `1.9.3-asm.2+config5`. You can also see all ASM git tags by running `curl https://storage.googleapis.com/csm-artifacts/asm/STABLE_VERSIONS`. You must provide the full and exact git tag. This variable is optional. Leaving it empty (default) will download the latest `install_asm` script for the version provided by the `asm_version` variable. | `string` | `""` | no |
| asm\_version | ASM version to deploy. This module supports versions `1.8`, `1.9` and `1.10`. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages | `string` | `"1.9"` | no |
| ca | Sets CA option. Possible values are `meshca` or `citadel`. Additional documentation on Citadel is available at https://cloud.google.com/service-mesh/docs/scripted-install/gke-install#installation_with_citadel_as_the_ca. | `string` | `"meshca"` | no |
| ca\_certs | Sets CA certificate file paths when `ca` is set to `citadel`. These values must be provided when using Citadel as CA. Additional documentation on Citadel is available at https://cloud.google.com/service-mesh/docs/scripted-install/gke-install#installation_with_citadel_as_the_ca. | `map(any)` | `{}` | no |
| cluster\_endpoint | The GKE cluster endpoint. | `string` | n/a | yes |
| cluster\_name | The unique name to identify the cluster in ASM. | `string` | n/a | yes |
| custom\_overlays | Comma separated list of custom\_overlay file paths. Works with in-cluster control plane only. Additional documentation available at https://cloud.google.com/service-mesh/docs/scripted-install/gke-install#installation_with_an_overlay_file | `list(any)` | `[]` | no |
| enable\_all | Sets `--enable_all` option if true. | `bool` | `false` | no |
| enable\_cluster\_labels | Sets `--enable_cluster_labels` option if true. | `bool` | `false` | no |
| enable\_cluster\_roles | Sets `--enable_cluster_roles` option if true. | `bool` | `false` | no |
| enable\_gcp\_apis | Sets `--enable_gcp_apis` option if true. | `bool` | `false` | no |
| enable\_gcp\_components | Sets --enable\_gcp\_components option if true. Can be true or false. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages | `bool` | `false` | no |
| enable\_gcp\_iam\_roles | Grants IAM roles required for ASM if true. If enable\_gcp\_iam\_roles, one of impersonate\_service\_account, service\_account, or iam\_member must be set. | `bool` | `false` | no |
| enable\_namespace\_creation | Sets `--enable_namespace_creation` option if true. | `bool` | `false` | no |
| enable\_registration | Sets `--enable_registration` option if true. | `bool` | `false` | no |
| gcloud\_sdk\_version | The gcloud sdk version to use. Minimum required version is 293.0.0 | `string` | `"296.0.1"` | no |
| iam\_member | The GCP member email address to grant IAM roles to. If impersonate\_service\_account or service\_account is set, roles are granted to that SA. | `string` | `""` | no |
| impersonate\_service\_account | An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials. | `string` | `""` | no |
| key\_file | The GCP Service Account credentials file path used to deploy ASM. | `string` | `""` | no |
| location | The location (zone or region) this cluster has been created in. | `string` | n/a | yes |
| managed\_control\_plane | ASM managed control plane boolean. Determines whether to install ASM managed control plane. Installing ASM managed control plane does not install gateways. Documentation on how to install gateways with ASM MCP can be found at https://cloud.google.com/service-mesh/docs/managed-control-plane#install_istio_gateways_optional. | `bool` | `false` | no |
| mode | ASM mode for deployment. Supported modes are `install` and `upgrade`. | `string` | `"install"` | no |
| options | Comma separated list of options. Works with in-cluster control plane only. Supported options are documented in https://cloud.google.com/service-mesh/docs/enable-optional-features. | `list(any)` | `[]` | no |
| outdir | Sets `--outdir` option. | `string` | `"none"` | no |
| project\_id | The project in which the resource belongs. | `string` | n/a | yes |
| revision\_name | Sets `--revision-name` option. | `string` | `"none"` | no |
| service\_account | The GCP Service Account email address used to deploy ASM. | `string` | `""` | no |
| service\_account\_key\_file | Path to service account key file to auth as for running `gcloud container clusters get-credentials`. | `string` | `""` | no |
| skip\_validation | Sets `_CI_NO_VALIDATE` variable. Determines whether the script should perform validation checks for prerequisites such as IAM roles, Google APIs etc. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| asm\_wait | An output to use when you want to depend on ASM finishing |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
