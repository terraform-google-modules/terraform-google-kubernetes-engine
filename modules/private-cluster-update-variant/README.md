# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc. This particular submodule creates a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `configure_ip_masq` is true

Sub modules are provided from creating private clusters, beta private clusters, and beta public clusters as well.  Beta sub modules allow for the use of various GKE beta features. See the modules directory for the various sub modules.

## Private Cluster Details
For details on configuring private clusters with this module, check the [troubleshooting guide](../../docs/private_clusters.md).

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

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform
0.11.x-compatible version of this module, the last released version
intended for Terraform 0.11.x is [3.0.0].

## Usage
There are multiple examples included in the [examples](./examples/) folder but simple usage is as follows:

```hcl
module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster-update-variant"
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
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "10.0.0.0/28"

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-2"
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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| add\_cluster\_firewall\_rules | Create additional firewall rules | bool | `"false"` | no |
| basic\_auth\_password | The password to be used with Basic Authentication. | string | `""` | no |
| basic\_auth\_username | The username to be used with Basic Authentication. An empty value will disable Basic Authentication, which is the recommended configuration. | string | `""` | no |
| cluster\_ipv4\_cidr | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | string | `"null"` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | map(string) | `<map>` | no |
| configure\_ip\_masq | Enables the installation of ip masquerading, which is usually no longer required when using aliasied IP addresses. IP masquerading uses a kubectl call, so when you have a private cluster, you will need access to the API server. | string | `"false"` | no |
| create\_service\_account | Defines if service account specified to run nodes should be created. | bool | `"true"` | no |
| default\_max\_pods\_per\_node | The maximum number of pods to schedule per node | string | `"110"` | no |
| deploy\_using\_private\_endpoint | (Beta) A toggle for Terraform and kubectl to connect to the master's internal IP address during deployment. | bool | `"false"` | no |
| description | The description of the cluster | string | `""` | no |
| disable\_legacy\_metadata\_endpoints | Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated. | bool | `"true"` | no |
| enable\_network\_egress\_export | Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic. | bool | `"false"` | no |
| enable\_private\_endpoint | (Beta) Whether the master's internal IP address is used as the cluster endpoint | bool | `"false"` | no |
| enable\_private\_nodes | (Beta) Whether nodes have internal IP addresses only | bool | `"false"` | no |
| enable\_resource\_consumption\_export | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. | bool | `"true"` | no |
| firewall\_inbound\_ports | List of TCP ports for admission/webhook controllers | list(string) | `<list>` | no |
| firewall\_priority | Priority rule for firewall rules | number | `"1000"` | no |
| gcloud\_skip\_download | Whether to skip downloading gcloud (assumes gcloud is already available outside the module) | bool | `"true"` | no |
| gcloud\_upgrade | Whether to upgrade gcloud at runtime | bool | `"false"` | no |
| grant\_registry\_access | Grants created cluster-specific service account storage.objectViewer role. | bool | `"false"` | no |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | bool | `"true"` | no |
| http\_load\_balancing | Enable httpload balancer addon | bool | `"true"` | no |
| initial\_node\_count | The number of nodes to create in this cluster's default node pool. | number | `"0"` | no |
| ip\_masq\_link\_local | Whether to masquerade traffic to the link-local prefix (169.254.0.0/16). | bool | `"false"` | no |
| ip\_masq\_resync\_interval | The interval at which the agent attempts to sync its ConfigMap file from the disk. | string | `"60s"` | no |
| ip\_range\_pods | The _name_ of the secondary subnet ip range to use for pods | string | n/a | yes |
| ip\_range\_services | The _name_ of the secondary subnet range to use for services | string | n/a | yes |
| issue\_client\_certificate | Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive! | bool | `"false"` | no |
| kubernetes\_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | string | `"latest"` | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | string | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_start\_time | Time window specified for daily or recurring maintenance operations in RFC3339 format | string | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | object | `<list>` | no |
| master\_ipv4\_cidr\_block | (Beta) The IP range in CIDR notation to use for the hosted master network | string | `"10.0.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | string | `"monitoring.googleapis.com/kubernetes"` | no |
| name | The name of the cluster (required) | string | n/a | yes |
| network | The VPC network to host the cluster in (required) | string | n/a | yes |
| network\_policy | Enable network policy addon | bool | `"true"` | no |
| network\_policy\_provider | The network policy provider. | string | `"CALICO"` | no |
| network\_project\_id | The project ID of the shared VPC's host (for shared vpc support) | string | `""` | no |
| node\_pools | List of maps containing node pools | list(map(string)) | `<list>` | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name | map(map(string)) | `<map>` | no |
| node\_pools\_metadata | Map of maps containing node metadata by node-pool name | map(map(string)) | `<map>` | no |
| node\_pools\_oauth\_scopes | Map of lists containing node oauth scopes by node-pool name | map(list(string)) | `<map>` | no |
| node\_pools\_tags | Map of lists containing node network tags by node-pool name | map(list(string)) | `<map>` | no |
| non\_masquerade\_cidrs | List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading. | list(string) | `<list>` | no |
| project\_id | The project ID to host the cluster in (required) | string | n/a | yes |
| region | The region to host the cluster in (optional if zonal cluster / required if regional) | string | `"null"` | no |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | bool | `"true"` | no |
| registry\_project\_id | Project holding the Google Container Registry. If empty, we use the cluster project. If grant_registry_access is true, storage.objectViewer role is assigned on this project. | string | `""` | no |
| remove\_default\_node\_pool | Remove default node pool while setting up the cluster | bool | `"false"` | no |
| resource\_usage\_export\_dataset\_id | The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export. | string | `""` | no |
| service\_account | The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created. | string | `""` | no |
| skip\_provisioners | Flag to skip all local-exec provisioners. It breaks `stub_domains` and `upstream_nameservers` variables functionality. | bool | `"false"` | no |
| stub\_domains | Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server | map(list(string)) | `<map>` | no |
| subnetwork | The subnetwork to host the cluster in (required) | string | n/a | yes |
| upstream\_nameservers | If specified, the values replace the nameservers taken by default from the node’s /etc/resolv.conf | list(string) | `<list>` | no |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | list(string) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| endpoint | Cluster endpoint |
| horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| http\_load\_balancing\_enabled | Whether http load balancing enabled |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| logging\_service | Logging service used |
| master\_authorized\_networks\_config | Networks from which access to master is permitted |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| master\_version | Current master kubernetes version |
| min\_master\_version | Minimum master kubernetes version |
| monitoring\_service | Monitoring service used |
| name | Cluster name |
| network\_policy\_enabled | Whether network policy enabled |
| node\_pools\_names | List of node pools names |
| node\_pools\_versions | List of node pools versions |
| peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| region | Cluster region |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| type | Cluster type (regional / zonal) |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## node_pools variable
The node_pools variable takes the following parameters:

| Name | Description | Default | Requirement |
| --- | --- | --- | --- |
| accelerator_count | The number of the guest accelerator cards exposed to this instance | 0 | Optional |
| accelerator_type | The accelerator type resource to expose to the instance | " " | Optional |
| enable_secure_boot | Secure Boot helps ensure that the system only runs authentic software by verifying the digital signature of all boot components, and halting the boot process if signature verification fails. | false | Optional |
| enable_integrity_monitoring | Enables monitoring and attestation of the boot integrity of the instance. The attestation is performed against the integrity policy baseline. This baseline is initially derived from the implicitly trusted boot image when the instance is created. | true | Optional |
| auto_repair | Whether the nodes will be automatically repaired | true | Optional |
| autoscaling | Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage | true | Optional |
| auto_upgrade | Whether the nodes will be automatically upgraded | true (if cluster is regional) | Optional |
| disk_size_gb | Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB | 100 | Optional |
| disk_type | Type of the disk attached to each node (e.g. 'pd-standard' or 'pd-ssd') | pd-standard | Optional |
| image_type | The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool | COS | Optional |
| initial_node_count | The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource. Defaults to the value of min_count | " " | Optional |
| local_ssd_count | The amount of local SSD disks that will be attached to each cluster node | 0 | Optional |
| machine_type | The name of a Google Compute Engine machine type | n1-standard-2 | Optional |
| max_count | Maximum number of nodes in the NodePool. Must be >= min_count | 100 | Optional |
| min_count | Minimum number of nodes in the NodePool. Must be >=0 and <= max_count. Should be used when autoscaling is true | 1 | Optional |
| name | The name of the node pool |  | Required |
| node_count | The number of nodes in the nodepool when autoscaling is false. Otherwise defaults to 1. Only valid for non-autoscaling clusers |  | Required |
| preemptible | A boolean that represents whether or not the underlying node VMs are preemptible | false | Optional |
| service_account | The service account to be used by the Node VMs | " " | Optional |
| tags | The list of instance tags applied to all nodes | | Required |
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
- [Terraform Provider for GCP][terraform-provider-google] v2.9

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

Additionally, if `service_account` is set to `create` and `grant_registry_access` is requested, the service account requires the following role on the `registry_project_id` project:
- roles/resourcemanager.projectIamAdmin

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com

[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
[3.0.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/3.0.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
