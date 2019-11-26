# Terraform Kubernetes Engine Shared VPC helper Submodule

This module could be used to enable easier shared VPC usage

Specifically, this module automates the following steps for shared VPC set up:
1. Activating Kubernetes Engine API for both host and service accounts.
2. Providing the necessary roles and permissions to the all needed subnets and GKE service accounts

## Usage
This module is a part of main GKE module and should be not used independently.
There is a [full example](../../examples/shared_vpc_with_helper) how it works with main GKE module.

 <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable\_shared\_vpc\_helper | Trigger if this submofule should be enabled. If false all resourcess creation will be skipped | bool | n/a | yes |
| gke\_sa | The service account in a service project to run GKE cluster nodes | string | n/a | yes |
| gke\_subnetwork | The host account subnetwork to share with service account (to host the GKE cluster in) | string | n/a | yes |
| gke\_svpc\_host\_project | The project ID of the shared VPC's host | string | n/a | yes |
| gke\_svpc\_service\_project | The project ID of the service account (to host the GKE cluster in) | string | n/a | yes |
| region | The region of subnets to share (to host the cluster in) | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gke\_host\_project\_id | The project ID of the shared VPC's host |
| gke\_service\_account | The service account in a service project to run GKE cluster nodes |
| gke\_service\_project\_id | The project ID of the service account (to host the GKE cluster in) |
| gke\_subnetwork | The host account subnetwork to share with service account (to host the GKE cluster in) |

 <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
