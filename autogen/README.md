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
## Private Cluster Endpoints
When creating a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters), nodes are provisioned with private IPs.
The Kubernetes master endpoint is also [locked down](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#access_to_the_cluster_endpoints), which affects these module features:
- `configure_ip_masq`
- `stub_domains`

If you are *not* using these features, then the module will function normally for private clusters and no special configuration is needed.
If you are using these features with a private cluster, you will need to either:
1. Run Terraform from a VM on the same VPC as your cluster (allowing it to connect to the private endpoint) and set `deploy_using_private_endpoint` to `true`.
2. Enable (beta) [route export functionality](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#master-on-prem-routing) to connect from an on-premise network over a VPN or Interconnect.
3. Include the external IP of your Terraform deployer in the `master_authorized_networks` configuration. Note that only IP addresses reserved in Google Cloud (such as in other VPCs) can be whitelisted.
4. Deploy a [bastion host](https://github.com/terraform-google-modules/terraform-google-bastion-host) or [proxy](https://cloud.google.com/solutions/creating-kubernetes-engine-private-clusters-with-net-proxies) in the same VPC as your GKE cluster.

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
      {% if beta_cluster %}
      node_locations     = "us-central1-b,us-central1-c"
      {% endif %}
      min_count          = 1
      max_count          = 100
      local_ssd_count    = 0
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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## node_pools variable
The node_pools variable takes the following parameters:

| Name | Description | Default | Requirement |
| --- | --- | --- | --- |
| accelerator_count | The number of the guest accelerator cards exposed to this instance | 0 | Optional |
| accelerator_type | The accelerator type resource to expose to the instance | " " | Optional |
| auto_repair | Whether the nodes will be automatically repaired | true | Optional |
| autoscaling | Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage | true | Optional |
| auto_upgrade | Whether the nodes will be automatically upgraded | true (if cluster is regional) | Optional |
| disk_size_gb | Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB | 100GB | Optional |
| disk_type | Type of the disk attached to each node (e.g. 'pd-standard' or 'pd-ssd') | pd-standard | Optional |
{% if beta_cluster %}
| effect | Effect for the taint | | Required |
{% endif %}
| image_type | The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool | COS | Optional |
| initial_node_count | The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource. Defaults to the value of min_count | " " | Optional |
{% if beta_cluster %}
| key | The key required for the taint | | Required |
{% endif %}
| local_ssd_count | The amount of local SSD disks that will be attached to each cluster node | 0 | Optional |
| machine_type | The name of a Google Compute Engine machine type | n1-standard-2 | Optional |
| max_count | Maximum number of nodes in the NodePool. Must be >= min_count | 100 | Optional |
{% if beta_cluster %}
| max_pods_per_node | The maximum number of pods per node in this cluster | null | Optional |
{% endif %}
| min_count | Minimum number of nodes in the NodePool. Must be >=0 and <= max_count. Should be used when autoscaling is true | 1 | Optional |
| name | The name of the node pool |  | Required |
| node_count | The number of nodes in the nodepool when autoscaling is false. Otherwise defaults to 1. Only valid for non-autoscaling clusers |  | Required |
{% if beta_cluster %}
| node_locations | The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. Defaults to cluster level node locations if nothing is specified | " " | Optional |
| node_metadata | Options to expose the node metadata to the workload running on the node | | Required |
{% endif %}
| preemptible | A boolean that represents whether or not the underlying node VMs are preemptible | false | Optional |
{% if beta_cluster %}
| sandbox_type | Sandbox to use for pods in the node pool | | Required |
{% endif %}
| service_account | The service account to be used by the Node VMs | " " | Optional |
| tags | The list of instance tags applied to all nodes | | Required |
{% if beta_cluster %}
| value | The value for the taint | | Required |
{% endif %}
| version | The Kubernetes version for the nodes in this pool. Should only be set if auto_upgrade is false | " " | Optional |


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

{% if beta_cluster %}
[terraform-provider-google-beta]: https://github.com/terraform-providers/terraform-provider-google-beta
{% else %}
[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
{% endif %}
[3.0.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/3.0.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
