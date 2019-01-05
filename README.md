# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.

The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `network_policy` is true

## Usage
There are multiple examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "<PROJECT ID>"
  name                       = "gke-test-1"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = "vpc-01"
  subnetwork                 = "us-central1-01"
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true

  node_pools = [
    {
      name            = "default-node-pool"
      machine_type    = "n1-standard-2"
      min_count       = 1
      max_count       = 100
      disk_size_gb    = 100
      disk_type       = "pd-standard"
      image_type      = "COS"
      auto_repair     = true
      auto_upgrade    = true
      service_account = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible     = false
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
| description | The description of the cluster | string | `` | no |
| horizontal_pod_autoscaling | Enable horizontal pod autoscaling addon | string | `true` | no |
| http_load_balancing | Enable httpload balancer addon | string | `true` | no |
| ip_masq_link_local | Whether to masquerade traffic to the link-local prefix (169.254.0.0/16). | string | `false` | no |
| ip_masq_resync_interval | The interval at which the agent attempts to sync its ConfigMap file from the disk. | string | `60s` | no |
| ip_range_pods | The secondary ip range to use for pods | string | - | yes |
| ip_range_services | The secondary ip range to use for pods | string | - | yes |
| kubernetes_dashboard | Enable kubernetes dashboard addon | string | `false` | no |
| kubernetes_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | string | `latest` | no |
| logging_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | string | `logging.googleapis.com` | no |
| maintenance_start_time | Time window specified for daily maintenance operations in RFC3339 format | string | `05:00` | no |
| master_authorized_networks_config | The desired configuration options for master authorized networks. Omit the nested cidr_blocks attribute to disallow external access (except the cluster node IPs, which GKE automatically whitelists)<br><br>  ### example format ###   master_authorized_networks_config = [{     cidr_blocks = [{       cidr_block   = "10.0.0.0/8"       display_name = "example_network"     }],   }] | list | `<list>` | no |
| monitoring_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | string | `monitoring.googleapis.com` | no |
| name | The name of the cluster (required) | string | - | yes |
| network | The VPC network to host the cluster in (required) | string | - | yes |
| network_policy | Enable network policy addon | string | `false` | no |
| network_project_id | The project ID of the shared VPC's host (for shared vpc support) | string | `` | no |
| remove_default_node_pool | Boolean value determining removal of default node pool | bool | false | no |
| node_pools | List of maps containing node pools | list | `<list>` | no |
| node_pools_labels | Map of maps containing node labels by node-pool name | map | `<map>` | no |
| node_pools_tags | Map of lists containing node network tags by node-pool name | map | `<map>` | no |
| node_pools_taints | Map of lists containing node taints by node-pool name | map | `<map>` | no |
| node_version | The Kubernetes version of the node pools. Defaults kubernetes_version (master) variable and can be overridden for individual node pools by setting the `version` key on them. Must be empyty or set the same as master at cluster creation. | string | `` | no |
| non_masquerade_cidrs | List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading. | list | `<list>` | no |
| project_id | The project ID to host the cluster in (required) | string | - | yes |
| region | The region to host the cluster in (required) | string | - | yes |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | string | `true` | no |
| service_account | The service account to default running nodes as if not overridden in `node_pools`. Defaults to the compute engine default service account | string | `` | no |
| stub_domains | Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server | map | `<map>` | no |
| subnetwork | The subnetwork to host the cluster in (required) | string | - | yes |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca_certificate | Cluster ca certificate (base64 encoded) |
| endpoint | Cluster endpoint |
| horizontal_pod_autoscaling_enabled | Whether horizontal pod autoscaling enabled |
| http_load_balancing_enabled | Whether http load balancing enabled |
| kubernetes_dashboard_enabled | Whether kubernetes dashboard enabled |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| logging_service | Logging service used |
| master_authorized_networks_config | Networks from which access to master is permitted |
| master_version | Current master kubernetes version |
| min_master_version | Minimum master kubernetes version |
| monitoring_service | Monitoring service used |
| name | Cluster name |
| network_policy_enabled | Whether network policy enabled |
| node_pools_names | List of node pools names |
| node_pools_versions | List of node pools versions |
| region | Cluster region |
| type | Cluster type (regional / zonal) |
| zones | List of zones in which the cluster resides |

[^]: (autogen_docs_end)

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#iam-roles).
3. The Compute Engine and Kubernetes Engine APIs are [active](#enable-apis) on the project you will launch the cluster in.
4. If you are using a Shared VPC, the APIs must also be activated on the Shared VPC host project and your service account needs the proper permissions there.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active and the necessary Shared VPC connections.

### Software Dependencies
### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases) 1.9.x
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.10.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v1.8.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.viewer
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountUser

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

## Install

### Terraform
Be sure you have the correct Terraform version (0.10.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

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
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.3.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

Six test-kitchen instances are defined:

- `deploy_service`
- `node_pool`
- `shared_vpc`
- `simple_regional`
- `simple_zonal`
- `stub_domains`

The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples/` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `credentials.json`.
3. Build the Docker containers for testing:

  ```
  make docker_build_terraform
  make docker_build_kitchen_terraform
  ```
4. Run the testing container in interactive mode:

  ```
  make docker_run
  ```

  The module root directory will be loaded into the Docker container at `/cftk/workdir/`.
5. Run kitchen-terraform to test the infrastructure:

  1. `kitchen create` creates Terraform state and downloads modules, if applicable.
  2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
  3. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
  4. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `make test_integration_docker` to run all the test steps non-interactively.

#### Test configuration

Each test-kitchen instance is configured with a `variables.tfvars` file in the test fixture directory, e.g. `test/fixtures/node_pool/terraform.tfvars`.
For convenience, since all of the variables are project-specific, these files have been symlinked to `test/fixtures/shared/terraform.tfvars`. 
Similarly, each test fixture has a `variables.tf` to define these variables, and an `outputs.tf` to facilitate providing necessary information for `inspec` to locate and query against created resources.

Each test-kitchen instance creates a GCP Network and Subnetwork fixture to house resources, and may create any other necessary fixture data as needed.

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

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
