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

| Name                     | Description                                                                                                                     | Type     | Default     | Required |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------- | -------- | ----------- | :------: |
| asm_dir                  | Name of directory to keep ASM resource config files.                                                                            | `string` | `"asm-dir"` |    no    |
| asm_version              | ASM version to deploy. Available versions are documented in https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages | `string` | `"1.8"`     |    no    |
| cluster_endpoint         | The GKE cluster endpoint.                                                                                                       | `string` | n/a         |   yes    |
| cluster_name             | The unique name to identify the cluster in ASM.                                                                                 | `string` | n/a         |   yes    |
| gcloud_sdk_version       | The gcloud sdk version to use. Minimum required version is 293.0.0                                                              | `string` | `"296.0.1"` |    no    |
| location                 | The location (zone or region) this cluster has been created in.                                                                 | `string` | n/a         |   yes    |
| project_id               | The project in which the resource belongs.                                                                                      | `string` | n/a         |   yes    |
| service_account_key_file | Path to service account key file to auth as for running `gcloud container clusters get-credentials`.                            | `string` | `""`        |    no    |

## Outputs

| Name     | Description                                               |
| -------- | --------------------------------------------------------- |
| asm_wait | An output to use when you want to depend on ASM finishing |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
