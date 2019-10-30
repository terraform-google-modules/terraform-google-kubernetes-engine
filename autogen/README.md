# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.{% if private_cluster %} This particular submodule creates a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters){% endif %}{% if beta_cluster %}Beta features are enabled in this submodule.{% endif %}

The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `configure_ip_masq` is true

Sub modules are provided from creating private clusters, beta private clusters, and beta public clusters as well.  Beta sub modules allow for the use of various GKE beta features. See the modules directory for the various sub modules.

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
  source                     = "terraform-google-modules/kubernetes-engine/google{{ module_path }}"
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

<!-- do not understand what this is about -->
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
{% if beta_cluster %}
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

Additionally, if `service_account` is set to `create` and `grant_registry_access` is requested, the service account requires the following role on the `registry_project_id` project:
- roles/resourcemanager.projectIamAdmin

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

## File structure
The project has the following folders and files:

- /: root folder
- /examples: Examples for using this module and sub module.
- /helpers: Helper scripts.
- /scripts: Scripts for specific tasks on module (see Infrastructure section on this file).
- /test: Folders with files for testing the module (see Testing section on this file).
- /main.tf: `main` file for the public module, contains all the resources to create.
- /variables.tf: Variables for the public cluster module.
- /output.tf: The outputs for the public cluster module.
- /README.MD: This file.
- /modules: Private and beta sub modules.


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
{% if beta_cluster %}
[terraform-provider-google-beta]: https://github.com/terraform-providers/terraform-provider-google-beta
{% else %}
[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
{% endif %}
[3.0.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/3.0.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
