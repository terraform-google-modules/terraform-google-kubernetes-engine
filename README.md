# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc.
The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `configure_ip_masq` is true

Sub modules are provided from creating private clusters, beta private clusters, and beta public clusters as well.  Beta sub modules allow for the use of various GKE beta features. See the modules directory for the various sub modules.


## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded][terraform-0.12-upgrade] and need a Terraform
0.11.x-compatible version of this module, the last released version
intended for Terraform 0.11.x is [3.0.0].

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
  network_policy             = true

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
<<<<<<< HEAD
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| basic\_auth\_password | The password to be used with Basic Authentication. | string | `""` | no |
| basic\_auth\_username | The username to be used with Basic Authentication. An empty value will disable Basic Authentication, which is the recommended configuration. | string | `""` | no |
| cluster\_ipv4\_cidr | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | string | `""` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | map(string) | `<map>` | no |
| configure\_ip\_masq | Enables the installation of ip masquerading, which is usually no longer required when using aliasied IP addresses. IP masquerading uses a kubectl call, so when you have a private cluster, you will need access to the API server. | string | `"false"` | no |
| create\_service\_account | Defines if service account specified to run nodes should be created. | bool | `"true"` | no |
| description | The description of the cluster | string | `""` | no |
| disable\_legacy\_metadata\_endpoints | Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated. | bool | `"true"` | no |
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
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | string | `"logging.googleapis.com"` | no |
| maintenance\_start\_time | Time window specified for daily maintenance operations in RFC3339 format | string | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | object | `<list>` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | string | `"monitoring.googleapis.com"` | no |
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
| node\_version | The Kubernetes version of the node pools. Defaults kubernetes_version (master) variable and can be overridden for individual node pools by setting the `version` key on them. Must be empyty or set the same as master at cluster creation. | string | `""` | no |
| non\_masquerade\_cidrs | List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading. | list(string) | `<list>` | no |
| project\_id | The project ID to host the cluster in (required) | string | n/a | yes |
| region | The region to host the cluster in (optional if zonal cluster / required if regional) | string | `"null"` | no |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | bool | `"true"` | no |
| registry\_project\_id | Project holding the Google Container Registry. If empty, we use the cluster project. If grant_registry_access is true, storage.objectViewer role is assigned on this project. | string | `""` | no |
| remove\_default\_node\_pool | Remove default node pool while setting up the cluster | bool | `"false"` | no |
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
| master\_version | Current master kubernetes version |
| min\_master\_version | Minimum master kubernetes version |
| monitoring\_service | Monitoring service used |
| name | Cluster name |
| network\_policy\_enabled | Whether network policy enabled |
| node\_pools\_names | List of node pools names |
| node\_pools\_versions | List of node pools versions |
| region | Cluster region |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| type | Cluster type (regional / zonal) |
| zones | List of zones in which the cluster resides |

=======
>>>>>>> Fixed Errors
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
- [Terraform Provider for GCP][terraform-provider-google] v2.9

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

## node_pools variable
The node_pools variable takes the following parameters:

| Name | Description | Default | Requirement | 
| --- | --- | --- | --- |
| auto_repair | Whether the nodes will be automatically repaired | true | Optional |
| autoscaling | Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage | true | Optional |
| auto_upgrade | Whether the nodes will be automatically upgraded | true (if cluster is regional) | Optional |
| disk_size_gb | Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB | 100GB | Optional |
| disk_type | Type of the disk attached to each node (e.g. 'pd-standard' or 'pd-ssd') | pd-standard | Optional |
| image_type | The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool | COS | Optional |
| initial_node_count | The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone. Changing this will force recreation of the resource | 0 | Optional |
| machine_type | The name of a Google Compute Engine machine type | n1-standard-2 | Optional |
| max_count | Maximum number of nodes in the NodePool. Must be >= min_count | 100 | Optional |
| min_count | Minimum number of nodes in the NodePool. Must be >=0 and <= max_count | 1 | Optional |
| name | The name of the node pool | " " | Optional |
| node_count | The number of nodes in the nodepool when autoscaling is false | 2 | Required (when autoscaling is false) |
| node_locations | The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters | " " | Optional |
| preemptible | A boolean that represents whether or not the underlying node VMs are preemptible | false | Optional |
| service_account | The service account to be used by the Node VMs | " " | Optional |

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

[terraform-provider-google]: https://github.com/terraform-providers/terraform-provider-google
[3.0.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/3.0.0
[terraform-0.12-upgrade]: https://www.terraform.io/upgrade-guides/0-12.html
