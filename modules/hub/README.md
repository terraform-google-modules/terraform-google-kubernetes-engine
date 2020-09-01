# Terraform Kubernetes Engine Hub Submodule

This module [registers a Kubernetes cluster](https://cloud.google.com/anthos/multicluster-management/connect/registering-a-cluster) in an Anthos [Environ](https://cloud.google.com/anthos/multicluster-management/environs).

Specifically, this module automates the following steps for [registering a cluster](https://cloud.google.com/anthos/multicluster-management/connect/registering-a-cluster#register_cluster)

## Usage

There is a [full example](../../examples/simple_zonal_with_asm) provided. Simple usage is as follows:

```tf
module "hub" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/hub"

  project_id       = "my-project-id"
  cluster_name     = "my-cluster-name"
  location         = module.gke.location
  cluster_endpoint = module.gke.endpoint
}
```

To deploy this config:
1. Run `terraform apply`

## Requirements

- Anthos [Environs](https://cloud.google.com/anthos/multicluster-management/environs) require an active Anthos license.



 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_endpoint | The GKE cluster endpoint. | string | n/a | yes |
| cluster\_name | The unique name to identify the cluster in ASM. | string | n/a | yes |
| enable\_gke\_hub\_registration | Enables GKE Hub Registration when set to true | bool | `"true"` | no |
| gcloud\_sdk\_version | The gcloud sdk version to use. Minimum required version is 293.0.0 | string | `"296.0.1"` | no |
| gke\_hub\_membership\_name | Memebership name that uniquely represents the cluster being registered on the Hub | string | `"gke-hub-membership"` | no |
| gke\_hub\_sa\_name | Name for the GKE Hub SA stored as a secret `creds-gcp` in the `gke-connect` namespace. | string | `"gke-hub-sa"` | no |
| location | The location (zone or region) this cluster has been created in. | string | n/a | yes |
| project\_id | The project in which the resource belongs. | string | n/a | yes |
| skip\_gcloud\_download | Whether to skip downloading gcloud (assumes gcloud and kubectl already available outside the module) | bool | `"true"` | no |
| use\_tf\_google\_credentials\_env\_var | Optional GOOGLE_CREDENTIALS environment variable to be activated. | bool | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| wait | An output to use when you want to depend on registration finishing |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
