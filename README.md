# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.

## Requirements
### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases) 1.9.x
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the following:

#### Roles
The service account with the following roles:
- roles/compute.viewer on the project
- roles/container.clusterAdmin on the project

### Enable API's
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## Usage
There are multiple examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "gke" {
  source                     = "github.com/terraform-google-modules/terraform-google-kubernetes-engine"
  project_id                 = "<PROJECT ID>"
  name                       = "gke-test-1"
  region                     = "us-central1"
  network                    = "vpc-01"
  subnetwork                 = "us-central1-01"
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  node_service_account       = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true

  node_pools = [
    {
      name         = "default-node-pool"
      machine_type = "n1-standard-2"
      min_count    = 1
      max_count    = 100
      disk_size_gb = 100
      disk_type    = "pd-standard"
      image_type   = "COS"
      auto_repair  = true
      auto_upgrade = true
    },
  ]

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = "true"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_zones | The zone to host the cluster in (optional: only used if is a zonal cluster) | list | `<list>` | no |
| description | The description of the cluster | string | `` | no |
| horizontal_pod_autoscaling | Enable horizontal pod autoscaling addon | string | `false` | no |
| http_load_balancing | Enable httpload balancer addon | string | `true` | no |
| ip_masq_link_local | Whether to masquerade traffic to the link-local prefix (169.254.0.0/16). | string | `false` | no |
| ip_masq_resync_interval | The interval at which the agent attempts to sync its ConfigMap file from the disk. | string | `60s` | no |
| ip_range_pods | The secondary ip range to use for pods | string | - | yes |
| ip_range_services | The secondary ip range to use for pods | string | - | yes |
| kubernetes_dashboard | Enable kubernetes dashboard addon | string | `false` | no |
| kubernetes_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | string | `1.10.5-gke.4` | no |
| maintenance_start_time | Time window specified for daily maintenance operations in RFC3339 format | string | `05:00` | no |
| name | The name of the cluster (required) | string | - | yes |
| network | The VPC network to host the cluster in (required) | string | - | yes |
| network_policy | Enable network policy addon | string | `false` | no |
| network_project_id | The project ID of the shared VPC's host (for shared vpc support) | string | `` | no |
| node_pools | List of maps containing node pools | list | `<list>` | no |
| node_pools_labels | Map of maps containing node labels by node-pool name | map | `<map>` | no |
| node_pools_tags | Map of lists containing node network tags by node-pool name | map | `<map>` | no |
| node_pools_taints | Map of lists containing node taints by node-pool name | map | `<map>` | no |
| node_service_account | Service account to associate to the nodes. Defaults to the compute default service account on the project.) | string | `` | no |
| node_version | The Kubernetes version of the node pools. Defaults kubernetes version (master) variable. Must set the same as master at initial creation. | string | `` | no |
| non_masquerade_cidrs | List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading. | list | `<list>` | no |
| project_id | The project ID to host the cluster in (required) | string | - | yes |
| region | The region to host the cluster in (required) | string | - | yes |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | string | `true` | no |
| stub_domains | Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server | map | `<map>` | no |
| subnetwork | The subnetwork to host the cluster in (required) | string | - | yes |
| zone | The zone to host the cluster in (required if is a zonal cluster) | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca_certificate | Cluster ca certificate (base64 encoded) |
| endpoint | Cluster endpoint |
| horizontal_pod_autoscaling_enabled | Whether horizontal pod autoscaling enabled |
| http_load_balancing_enabled | Whether http load balancing enabled |
| kubernetes_dashboard_enabled | Whether kubernetes dashboard enabled |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| master_version | Current master kubernetes version |
| min_master_version | Minimum master kubernetes version |
| name | Cluster name |
| network_policy_enabled | Whether network policy enabled |
| node_pools_names | List of node pools names |
| node_version | Current node kubernetes version |
| region | Cluster region |
| zones | List of zones in which the cluster resides |

[^]: (autogen_docs_end)

## Infrastructure
The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `network_policy` is true

## File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /scripts: Scripts for specific tasks on module (see Infrastructure section on this file)
- /test: Folders with files for testing the module (see Testing section on this file)
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /readme.MD: this file

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [jq](https://stedolan.github.io/jq/) 1.5
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test
#### Terraform integration tests
The integration tests for this module leverage [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform) and [kitchen-inspec](https://github.com/inspec/kitchen-inspec).

The tests will do the following:
- Perform `bundle install` command
  - Installs `kitchen-terraform` and `kitchen-inspec` gems
- Perform `kitchen create` command
  - Performs a `terraform init`
- Perform `kitchen converge` command
  - Performs a `terraform apply -auto-approve`
- Perform `kitchen validate` command
  - Performs inspec tests.
    - Inspec tests shell out to gcloud to validate expected resources in GCP.
- Permos `kitchen destroy` command
  - Performs a `terraform destroy -force`

You can use the following command to run the integration test in the root folder

  `make test_integration`

### Linting
The makefile in this project will lint or sometimes just format any shell,
Python, golang, Terraform, or Dockerfiles. The linters will only be run if
the makefile finds files with the appropriate file extension.

All of the linter checks are in the default make target, so you just have to
run

```
make -s
```

The -s is for 'silent'. Successful output looks like this

```
Running shellcheck
Running flake8
Running go fmt and go vet
Running terraform validate
Running hadolint on Dockerfiles
Checking for required files
Testing the validity of the header check
..
----------------------------------------------------------------------
Ran 2 tests in 0.026s

OK
Checking file headers
The following lines have trailing whitespace
```

The linters
are as follows:
* Shell - shellcheck. Can be found in homebrew
* Python - flake8. Can be installed with 'pip install flake8'
* Golang - gofmt. gofmt comes with the standard golang installation. golang
is a compiled language so there is no standard linter.
* Terraform - terraform has a built-in linter in the 'terraform validate'
command.
* Dockerfiles - hadolint. Can be found in homebrew