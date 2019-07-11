# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.{% if private_cluster %} This particular submodule creates a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters){% endif %}{% if beta_cluster %}Beta features are enabled on this submodule.{% endif %}

The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `network_policy` is true

{% if private_cluster %}
**Note**: You must run Terraform from a VM on the same VPC as your cluster, otherwise there will be issues connecting to the GKE master.

  {% endif %}

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform
0.11.x-compatible version of this module, the last released version
intended for Terraform 0.11.x is [3.0.0].

## Usage
There are multiple examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google{% if private_cluster %}//modules/private-cluster{% endif %}"
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
  {% if private_cluster %}
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.0.0/28"
  {% endif %}
  {% if beta_cluster %}
  istio = true
  cloudrun = true
  {% endif %}

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
      min_count          = 1
      max_count          = 100
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
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

## Upgrade to v3.0.0

v3.0.0 is a breaking release. Refer to the
[Upgrading to v3.0 guide][upgrading-to-v3.0] for details.

## Upgrade to v2.0.0

v2.0.0 is a breaking release. Refer to the
[Upgrading to v2.0 guide][upgrading-to-v2.0] for details.

## Upgrade to v1.0.0

Version 1.0.0 of this module introduces a breaking change: adding the `disable-legacy-endpoints` metadata field to all node pools. This metadata is required by GKE and [determines whether the `/0.1/` and `/v1beta1/` paths are available in the nodes' metadata server](https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata#disable-legacy-apis). If your applications do not require access to the node's metadata server, you can leave the default value of `true` provided by the module. If your applications require access to the metadata server, be sure to read the linked documentation to see if you need to set the value for this field to `false` to allow your applications access to the above metadata server paths.

In either case, upgrading to module version `v1.0.0` will trigger a recreation of all node pools in the cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The Compute Engine and Kubernetes Engine APIs are [active](#enable-apis) on the project you will launch the cluster in.
4. If you are using a Shared VPC, the APIs must also be activated on the Shared VPC host project and your service account needs the proper permissions there.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active and the necessary Shared VPC connections.

### Software Dependencies
#### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases) 1.9.x
#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12
{% if private_cluster or beta_cluster %}
- [Terraform Provider for GCP Beta][terraform-provider-google-beta] v2.9
{% else %}
- [Terraform Provider for GCP][terraform-provider-google] v2.9
{% endif %}

### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.viewer
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountAdmin
- roles/iam.serviceAccountUser
- roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

## File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /helpers: Helper scripts
- /scripts: Scripts for specific tasks on module (see Infrastructure section on this file)
- /test: Folders with files for testing the module (see Testing section on this file)
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /readme.MD: this file

## Templating

To more cleanly handle cases where desired functionality would require complex duplication of Terraform resources (i.e. [PR 51](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/pull/51)), this repository is largely generated from the [`autogen`](/autogen) directory.

The root module is generated by running `make generate`. Changes to this repository should be made in the [`autogen`](/autogen) directory where appropriate.

Note: The correct sequence to update the repo using autogen functionality is to run
`make generate && make generate_docs`.  This will create the various Terraform files, and then
generate the Terraform documentation using `terraform-docs`.

## Testing

### Requirements
- [bundler](https://github.com/bundler/bundler)
- [gcloud](https://cloud.google.com/sdk/install)
- [terraform-docs](https://github.com/segmentio/terraform-docs/releases) 0.6.0

### Autogeneration of documentation from .tf files
Run
```
make generate_docs
```

### Integration test

Integration tests are run though [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-terraform](https://github.com/newcontext-oss/kitchen-terraform), and [InSpec](https://github.com/inspec/inspec).

Six test-kitchen instances are defined:

- `deploy-service`
- `node-pool`
- `shared-vpc`
- `simple-regional`
- `simple-zonal`
- `stub-domains`

The test-kitchen instances in `test/fixtures/` wrap identically-named examples in the `examples/` directory.

#### Setup

1. Configure the [test fixtures](#test-configuration)
2. Download a Service Account key with the necessary permissions and put it in the module's root directory with the name `credentials.json`.
    - Requires the [permissions to run the module](#configure-a-service-account)
    - Requires `roles/compute.networkAdmin` to create the test suite's networks
    - Requires `roles/resourcemanager.projectIamAdmin` since service account creation is tested
3. Build the Docker container for testing:

  ```
  make docker_build_kitchen_terraform
  ```
4. Run the testing container in interactive mode:

  ```
  make docker_run
  ```

  The module root directory will be loaded into the Docker container at `/cft/workdir/`.
5. Run kitchen-terraform to test the infrastructure:

  1. `kitchen create` creates Terraform state and downloads modules, if applicable.
  2. `kitchen converge` creates the underlying resources. Run `kitchen converge <INSTANCE_NAME>` to create resources for a specific test case.
  3. Run `kitchen converge` again. This is necessary due to an oddity in how `networkPolicyConfig` is handled by the upstream API. (See [#72](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/72) for details).
  4. `kitchen verify` tests the created infrastructure. Run `kitchen verify <INSTANCE_NAME>` to run a specific test case.
  5. `kitchen destroy` tears down the underlying resources created by `kitchen converge`. Run `kitchen destroy <INSTANCE_NAME>` to tear down resources for a specific test case.

Alternatively, you can simply run `make test_integration_docker` to run all the test steps non-interactively.

If you wish to parallelize running the test suites, it is also possible to offload the work onto Concourse to run each test suite for you using the command `make test_integration_concourse`. The `.concourse` directory will be created and contain all of the logs from the running test suites.

When running tests locally, you will need to use your own test project environment. You can configure your environment by setting all of the following variables:

```
export COMPUTE_ENGINE_SERVICE_ACCOUNT="<EXISTING_SERVICE_ACCOUNT>"
export PROJECT_ID="<PROJECT_TO_USE>"
export REGION="<REGION_TO_USE>"
export ZONES='["<LIST_OF_ZONES_TO_USE>"]'
export SERVICE_ACCOUNT_JSON="$(cat "<PATH_TO_SERVICE_ACCOUNT_JSON>")"
export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="<PATH_TO_SERVICE_ACCOUNT_JSON>"
export GOOGLE_APPLICATION_CREDENTIALS="<PATH_TO_SERVICE_ACCOUNT_JSON>"
```

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

{% if private_cluster %}
[upgrading-to-v2.0]: ../../docs/upgrading_to_v2.0.md
{% else %}
[upgrading-to-v2.0]: docs/upgrading_to_v2.0.md
{% endif %}
{% if private_cluster or beta_cluster %}
[upgrading-to-v3.0]: ../../docs/upgrading_to_v3.0.md
{% else %}
[upgrading-to-v3.0]: docs/upgrading_to_v3.0.md
{% endif %}
{% if private_cluster or beta_cluster %}
[terraform-provider-google-beta]: https://github.com/terraform-providers/terraform-provider-google-beta
{% else %}
[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
{% endif %}
[3.0.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/3.0.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
