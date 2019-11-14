# Terraform Kubernetes Engine ACM Submodule

This module installs Anthos Config Management (ACM) in a Kubernetes cluster.
To find out more about ACM check [documentation](https://cloud.google.com/anthos-config-management/).


## Configure a Service Account

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

