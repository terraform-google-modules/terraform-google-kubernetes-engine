# Terraform Kubernetes Engine ACM Submodule

This module installs [Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/) (ACM) in a Kubernetes cluster.

Specifically, this module automates the following steps for [installing ACM](https://cloud.google.com/anthos-config-management/docs/how-to/installing):
1. Installing the ACM Operator on your cluster.
2. Generating an SSH key for accessing Git and providing it to the Operator
3. Configuring the Operator to connect to your ACM repository

## Usage

There is a [full example](../../examples/simple_zonal) provided. Simple usage is as follows:

```tf
module "acm" {
  source           = "../../modules/acm"
  project_id       = var.project_id
  location         = module.gke.location
  cluster_name     = module.gke.name
  sync_repo        = var.acm_sync_repo
  sync_branch      = var.acm_sync_branch
  policy_dir       = var.acm_policy_dir
  cluster_endpoint = module.gke.endpoint
}
```


In addition to this [example](../../examples/simple_zonal) shows how to provision a cluster and install ACm. 


In order to use this module, you must use a Service Account 

In order to use this module you must have Service Account with roles listed [Terraform Kubernetes Engine Module](../../README.md)
plus **roles/container.admin** role.

## Usage example

See [examples/simple_zonal](../../examples/simple_zonal) cluster example.

## Installation

This module automates the instructions described in the [Installing Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/how-to/installing) guide.
To enable Git access to the configuration repository over SSH, complete step 2 in the [Using an SSH keypair](https://cloud.google.com/anthos-config-management/docs/how-to/installing#git-creds-ssh) section using the SSH public key from the **git\_creds\_public** output.

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster\_endpoint | Kubernetes cluster endpoint. | string | n/a | yes |
| cluster\_name | The name of the cluster. | string | n/a | yes |
| location | The location (zone or region) this cluster has been created in. One of location, region, zone, or a provider-level zone must be specified. | string | n/a | yes |
| policy\_dir | Subfolder containing configs in Ahtons config management Git repo | string | n/a | yes |
| project\_id | The project in which the resource belongs. | string | n/a | yes |
| sync\_branch | Anthos config management Git branch | string | `"master"` | no |
| sync\_repo | Anthos config management Git repo | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| git\_creds\_public | Public key of SSH keypair to allow the Anthos Operator to authenticate to your Git repository. |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

