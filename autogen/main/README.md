# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.{% if private_cluster %} This particular submodule creates a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters){% endif %}{% if beta_cluster %}Beta features are enabled in this submodule.{% endif %}

The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `configure_ip_masq` is true

Sub modules are provided for creating private clusters, beta private clusters, and beta public clusters as well.  Beta sub modules allow for the use of various GKE beta features. See the modules directory for the various sub modules.

{% if private_cluster %}
## Private Cluster Details
For details on configuring private clusters with this module, check the [troubleshooting guide](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/docs/private_clusters.md).

{% endif %}
{% if update_variant %}
## Node Pool Update Variant

In [#256] update variants added support for node pools to be created before being destroyed.

Before, if a node pool has to be recreated for any number of reasons,
the node pool is deleted then, created. This can be a problem if it is the only node pool in the GKE
cluster and the new node pool cannot be provisioned. In this scenario, pods could not be scheduled.
[#256] allows a node pool to be created before it is deleted so that any issues with node pool creation
and/or provisioning are discovered before the node pool is removed. This feature is controlled by the
variable `node_pools_create_before_destroy`. In order to avoid node pool name collisions,
a 4 character alphanumeric is added as a suffix to the name.

The benefit is that you always have some node pools active.
We don't actually cordon/drain the traffic beyond what the GKE API itself will do,
but we do make sure the new node pool is created before the old one is destroyed.

The implications of this are that:

- We append a random ID on the node pool names (since you can't have two simultaneously active node pools)
- For a brief period, you'll have 2x as many resources/node pools
- You will indeed need sufficient IP space (and compute capacity) to create both node pools

{% endif %}
## Compatibility

This module is meant for use with Terraform 1.3+ and tested using Terraform 1.10+.
If you find incompatibilities using Terraform `>=1.3`, please open an issue.

If you haven't [upgraded to 1.3][terraform-1.3-upgrade] and need a Terraform
0.13.x-compatible version of this module, the last released version
intended for Terraform 0.13.x is [27.0.0].

If you haven't [upgraded to 0.13][terraform-0.13-upgrade] and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [12.3.0].

## Usage
There are multiple examples included in the [examples](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/examples) folder but simple usage is as follows:

```hcl
# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

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
  {% if autopilot_cluster != true %}
  http_load_balancing        = false
  network_policy             = false
  {% endif %}
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  {% if private_cluster %}
  enable_private_endpoint    = true
  enable_private_nodes       = true
  {% endif %}
  {% if beta_cluster and autopilot_cluster != true  %}
  istio                      = true
  cloudrun                   = true
  {% endif %}
  dns_cache                  = false

{% if autopilot_cluster != true %}
  node_pools = [
    {
      name                        = "default-node-pool"
      machine_type                = "e2-medium"
      node_locations              = "us-central1-b,us-central1-c"
      min_count                   = 1
      max_count                   = 100
      local_ssd_count             = 0
      spot                        = false
      {% if beta_cluster %}
      local_ssd_ephemeral_count   = 0
      {% endif %}
      disk_size_gb                = 100
      disk_type                   = "pd-standard"
      image_type                  = "COS_CONTAINERD"
      enable_gcfs                 = false
      enable_gvnic                = false
      logging_variant             = "DEFAULT"
      auto_repair                 = true
      auto_upgrade                = true
      service_account             = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible                 = false
      initial_node_count          = 80
      accelerator_count           = 1
      accelerator_type            = "nvidia-l4"
      gpu_driver_version          = "LATEST"
      gpu_sharing_strategy        = "TIME_SHARING"
      max_shared_clients_per_gpu = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
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
{% endif %}
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

{% if autopilot_cluster != true %}
## node_pools variable

> Use this variable for provisioning linux based node pools. For Windows based node pools use [windows_node_pools](#windows\_node\_pools-variable)

The node_pools variable takes the following parameters:

| Name | Description | Default | Requirement |
| --- | --- | --- | --- |
| accelerator_count | The number of the guest accelerator cards exposed to this instance | 0 | Optional |
| accelerator_type | The accelerator type resource to expose to the instance | " " | Optional |
| auto_repair | Whether the nodes will be automatically repaired | true | Optional |
| autoscaling | Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage | true | Optional |
| auto_upgrade | Whether the nodes will be automatically upgraded | true (if cluster is regional) | Optional |
| boot_disk_kms_key | The Customer Managed Encryption Key used to encrypt the boot disk attached to each node in the node pool. This should be of the form projects/[KEY_PROJECT_ID]/locations/[LOCATION]/keyRings/[RING_NAME]/cryptoKeys/[KEY_NAME]. | " " | Optional |
| cpu_manager_policy | The CPU manager policy on the node. One of "none" or "static". | "static" | Optional |
| cpu_cfs_quota | Enforces the Pod's CPU limit. Setting this value to false means that the CPU limits for Pods are ignored | null | Optional |
| cpu_cfs_quota_period | The CPU CFS quota period value, which specifies the period of how often a cgroup's access to CPU resources should be reallocated | null | Optional |
| pod_pids_limit | Controls the maximum number of processes allowed to run in a pod. The value must be greater than or equal to 1024 and less than 4194304. | null | Optional |
| enable_confidential_nodes | An optional flag to enable confidential node config. | false | Optional |
| disk_size_gb | Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB | 100 | Optional |
| disk_type | Type of the disk attached to each node (e.g. 'pd-standard' or 'pd-ssd') | pd-standard | Optional |
| effect | Effect for the taint | | Required |
| enable_fast_socket | Enable the NCCL Fast Socket feature. `enable_gvnic` must also be enabled. | null | Optional |
| enable_gcfs | Google Container File System (gcfs) has to be enabled for image streaming to be active. Needs image_type to be set to COS_CONTAINERD. | false | Optional |
| enable_gvnic | gVNIC (GVE) is an alternative to the virtIO-based ethernet driver. Needs a Container-Optimized OS node image. | false | Optional |
| enable_integrity_monitoring | Enables monitoring and attestation of the boot integrity of the instance. The attestation is performed against the integrity policy baseline. This baseline is initially derived from the implicitly trusted boot image when the instance is created. | true | Optional |
| enable_secure_boot | Secure Boot helps ensure that the system only runs authentic software by verifying the digital signature of all boot components, and halting the boot process if signature verification fails. | false | Optional |
| gpu_driver_version | Mode for how the GPU driver is installed | null | Optional |
| gpu_partition_size | Size of partitions to create on the GPU | null | Optional |
| image_type | The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool | COS_CONTAINERD | Optional |
| initial_node_count | The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource. Defaults to the value of min_count | " " | Optional |
| insecure_kubelet_readonly_port_enabled | (boolean) Whether or not to enable the insecure Kubelet readonly port. | null | Optional |
| key | The key required for the taint | | Required |
| logging_variant | The type of logging agent that is deployed by default for newly created node pools in the cluster. Valid values include DEFAULT and MAX_THROUGHPUT.  | DEFAULT | Optional |
| local_ssd_count | The amount of local SSD disks that will be attached to each cluster node and may be used as a `hostpath` volume or a `local` PersistentVolume.  | 0 | Optional |
| local_ssd_ephemeral_storage_count | The amount of local SSD disks that will be attached to each cluster node and assigned as scratch space as an `emptyDir` volume. If unspecified, ephemeral storage is backed by the cluster node boot disk. | 0 | Optional |
{% if beta_cluster %}
| local_ssd_ephemeral_count | The amount of local SSD disks that will be attached to each cluster node and assigned as scratch space as an `emptyDir` volume. If unspecified, ephemeral storage is backed by the cluster node boot disk. | 0 | Optional |
{% endif %}
| local_nvme_ssd_count | Number of raw-block local NVMe SSD disks to be attached to the node.Each local SSD is 375 GB in size. If zero, it means no raw-block local NVMe SSD disks to be attached to the node. | 0 | Optional |
| machine_type | The name of a Google Compute Engine machine type | e2-medium | Optional |
| min_cpu_platform | Minimum CPU platform to be used by the nodes in the pool. The nodes may be scheduled on the specified or newer CPU platform. | " " | Optional |
| enable_confidential_storage | Enabling Confidential Storage will create boot disk with confidential mode. | false | Optional |
| max_count | Maximum number of nodes in the NodePool. Must be >= min_count. Cannot be used with total limits. | 100 | Optional |
| total_max_count | Total maximum number of nodes in the NodePool. Must be >= min_count. Cannot be used with per zone limits. | null | Optional |
| max_pods_per_node | The maximum number of pods per node in this cluster | null | Optional |
| strategy | The upgrade stragey to be used for upgrading the nodes. Valid values of state are: `SURGE` or `BLUE_GREEN` | "SURGE" | Optional |
| threads_per_core | Optional The number of threads per physical core. To disable simultaneous multithreading (SMT) set this to 1. If unset, the maximum number of threads supported per core by the underlying processor is assumed | null | Optional |
| enable_nested_virtualization | Whether the node should have nested virtualization | null | Optional |
| max_surge | The number of additional nodes that can be added to the node pool during an upgrade. Increasing max_surge raises the number of nodes that can be upgraded simultaneously. Can be set to 0 or greater. Only works with `SURGE` strategy. | 1 | Optional |
| max_unavailable | The number of nodes that can be simultaneously unavailable during an upgrade. Increasing max_unavailable raises the number of nodes that can be upgraded in parallel. Can be set to 0 or greater. Only works with `SURGE` strategy. | 0 | Optional |
| node_pool_soak_duration | Time needed after draining the entire blue pool. After this period, the blue pool will be cleaned up. By default, it is set to one hour (3600 seconds). The maximum length of the soak time is 7 days (604,800 seconds). Only works with `BLUE_GREEN` strategy. | "3600s" | Optional |
| batch_soak_duration | Soak time after each batch gets drained, with the default being zero seconds. Only works with `BLUE_GREEN` strategy. | "0s" | Optional |
| batch_node_count | Absolute number of nodes to drain in a batch. If it is set to zero, this phase will be skipped. Cannot be used together with `batch_percentage`. Only works with `BLUE_GREEN` strategy. | 1 | Optional |
| batch_percentage | Percentage of nodes to drain in a batch. Must be in the range of [0.0, 1.0]. If it is set to zero, this phase will be skipped. Cannot be used together with `batch_node_count`. Only works with `BLUE_GREEN` strategy. | null | Optional |
| min_count | Minimum number of nodes in the NodePool. Must be >=0 and <= max_count. Should be used when autoscaling is true. Cannot be used with total limits. | 1 | Optional |
| total_min_count | Total minimum number of nodes in the NodePool. Must be >=0 and <= max_count. Should be used when autoscaling is true. Cannot be used with per zone limits. | null | Optional |
| name | The name of the node pool |  | Required |
| placement_policy | Placement type to set for nodes in a node pool. Can be set as [COMPACT](https://cloud.google.com/kubernetes-engine/docs/how-to/compact-placement#overview) if desired |  | Optional |
| pod_range |  The name of the secondary range for pod IPs. |  | Optional |
{% if not private_cluster %}
| enable_private_nodes |  Whether nodes have internal IP addresses only. |  | Optional |
{% endif %}
| node_count | The number of nodes in the nodepool when autoscaling is false. Otherwise defaults to 1. Only valid for non-autoscaling clusters |  | Required |
| node_locations | The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. Defaults to cluster level node locations if nothing is specified | " " | Optional |
| node_metadata | Options to expose the node metadata to the workload running on the node | | Optional |
| preemptible | A boolean that represents whether or not the underlying node VMs are preemptible | false | Optional |
| spot | A boolean that represents whether the underlying node VMs are spot | false | Optional |
{% if beta_cluster %}
| sandbox_type | Sandbox to use for pods in the node pool | | Required |
{% endif %}
| service_account | The service account to be used by the Node VMs | " " | Optional |
| tags | The list of instance tags applied to all nodes | | Required |
| value | The value for the taint | | Required |
| version | The Kubernetes version for the nodes in this pool. Should only be set if auto_upgrade is false | " " | Optional |
| location_policy | [Location policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#location_policy) specifies the algorithm used when scaling-up the node pool. Location policy is supported only in 1.24.1+ clusters. | " " | Optional |
| secondary_boot_disk | Image of a secondary boot disk to preload container images and data on new nodes. For detail see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_secondary_boot_disks). `gcfs_config` must be `enabled=true` for this feature to work. | | Optional |
| queued_provisioning | Makes nodes obtainable through the ProvisioningRequest API exclusively. | | Optional |
| gpu_sharing_strategy | The type of GPU sharing strategy to enable on the GPU node. Accepted values are: "TIME_SHARING" and "MPS". | | Optional |
| max_shared_clients_per_gpu | The maximum number of containers that can share a GPU. | | Optional |
| consume_reservation_type | The type of reservation consumption. Accepted values are: "UNSPECIFIED": Default value (should not be specified). "NO_RESERVATION": Do not consume from any reserved capacity, "ANY_RESERVATION": Consume any reservation available, "SPECIFIC_RESERVATION": Must consume from a specific reservation. Must specify key value fields for specifying the reservations. | | Optional |
| reservation_affinity_key | The label key of a reservation resource. To target a SPECIFIC_RESERVATION by name, specify "compute.googleapis.com/reservation-name" as the key and specify the name of your reservation as its value. | | Optional |
| reservation_affinity_values | The list of label values of reservation resources. For example: the name of the specific reservation when using a key of "compute.googleapis.com/reservation-name". This should be passed as comma separated string. | | Optional |

## windows_node_pools variable
The windows_node_pools variable takes the same parameters as [node_pools](#node\_pools-variable) but is reserved for provisioning Windows based node pools only. This variable is introduced to satisfy a [specific requirement](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-a-cluster-windows#create_a_cluster_and_node_pools) for the presence of at least one linux based node pool in the cluster before a windows based node pool can be created.

{% endif %}

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
- [Terraform](https://www.terraform.io/downloads.html) 1.3+
{% if beta_cluster %}
- [Terraform Provider for GCP Beta][terraform-provider-google-beta] v6.14+
{% else %}
- [Terraform Provider for GCP][terraform-provider-google] v6.14+
{% endif %}
#### gcloud
Some submodules use the [terraform-google-gcloud](https://github.com/terraform-google-modules/terraform-google-gcloud) module. By default, this module assumes you already have gcloud installed in your $PATH.
See the [module](https://github.com/terraform-google-modules/terraform-google-gcloud#downloading) documentation for more information.

### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.viewer
- roles/compute.securityAdmin (only required if `add_cluster_firewall_rules` is set to `true`)
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountAdmin
- roles/iam.serviceAccountUser
- roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

Additionally, if `service_account` is set to `create` and `grant_registry_access` is requested, the service account requires the following role on the `registry_project_ids` projects:
- roles/resourcemanager.projectIamAdmin

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

{% if beta_cluster %}
[terraform-provider-google-beta]: https://github.com/terraform-providers/terraform-provider-google-beta
{% else %}
[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
{% endif %}
[12.3.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/12.3.0
[terraform-0.13-upgrade]: https://www.terraform.io/upgrade-guides/0-13.html
[terraform-1.3-upgrade]: https://developer.hashicorp.com/terraform/language/v1.3.x/upgrade-guides
