# Terraform Kubernetes Engine Module

This module handles opinionated Google Cloud Platform Kubernetes Engine cluster creation and configuration with Node Pools, IP MASQ, Network Policy, etc. This particular submodule creates a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)Beta features are enabled in this submodule.
The resources/services/activations/deletions that this module will create/trigger are:
- Create a GKE cluster with the provided addons
- Create GKE Node Pool(s) with provided configuration and attach to cluster
- Replace the default kube-dns configmap if `stub_domains` are provided
- Activate network policy if `network_policy` is true
- Add `ip-masq-agent` configmap with provided `non_masquerade_cidrs` if `configure_ip_masq` is true

Sub modules are provided for creating private clusters, beta private clusters, and beta public clusters as well.  Beta sub modules allow for the use of various GKE beta features. See the modules directory for the various sub modules.

## Private Cluster Details
For details on configuring private clusters with this module, check the [troubleshooting guide](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/blob/master/docs/private_clusters.md).

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
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  project_id                 = "<PROJECT ID>"
  name                       = "gke-test-1"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = "vpc-01"
  subnetwork                 = "us-central1-01"
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = true
  enable_private_nodes       = true
  istio                      = true
  cloudrun                   = true
  dns_cache                  = false

  node_pools = [
    {
      name                        = "default-node-pool"
      machine_type                = "e2-medium"
      node_locations              = "us-central1-b,us-central1-c"
      min_count                   = 1
      max_count                   = 100
      local_ssd_count             = 0
      spot                        = false
      local_ssd_ephemeral_count   = 0
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
|------|-------------|------|---------|:--------:|
| add\_cluster\_firewall\_rules | Create additional firewall rules | `bool` | `false` | no |
| add\_master\_webhook\_firewall\_rules | Create master\_webhook firewall rules for ports defined in `firewall_inbound_ports` | `bool` | `false` | no |
| add\_shadow\_firewall\_rules | Create GKE shadow firewall (the same as default firewall rules with firewall logs enabled). | `bool` | `false` | no |
| additional\_ip\_range\_pods | List of _names_ of the additional secondary subnet ip ranges to use for pods | `list(string)` | `[]` | no |
| additive\_vpc\_scope\_dns\_domain | This will enable Cloud DNS additive VPC scope. Must provide a domain name that is unique within the VPC. For this to work cluster\_dns = `CLOUD_DNS` and cluster\_dns\_scope = `CLUSTER_SCOPE` must both be set as well. | `string` | `""` | no |
| authenticator\_security\_group | The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com | `string` | `null` | no |
| boot\_disk\_kms\_key | The Customer Managed Encryption Key used to encrypt the boot disk attached to each node in the node pool, if not overridden in `node_pools`. This should be of the form projects/[KEY\_PROJECT\_ID]/locations/[LOCATION]/keyRings/[RING\_NAME]/cryptoKeys/[KEY\_NAME]. For more information about protecting resources with Cloud KMS Keys please see: https://cloud.google.com/compute/docs/disks/customer-managed-encryption | `string` | `null` | no |
| cloudrun | (Beta) Enable CloudRun addon | `bool` | `false` | no |
| cloudrun\_load\_balancer\_type | (Beta) Configure the Cloud Run load balancer type. External by default. Set to `LOAD_BALANCER_TYPE_INTERNAL` to configure as an internal load balancer. | `string` | `""` | no |
| cluster\_autoscaling | Cluster autoscaling configuration. See [more details](https://cloud.google.com/kubernetes-engine/docs/reference/rest/v1beta1/projects.locations.clusters#clusterautoscaling) | <pre>object({<br>    enabled                     = bool<br>    autoscaling_profile         = string<br>    min_cpu_cores               = number<br>    max_cpu_cores               = number<br>    min_memory_gb               = number<br>    max_memory_gb               = number<br>    gpu_resources               = list(object({ resource_type = string, minimum = number, maximum = number }))<br>    auto_repair                 = bool<br>    auto_upgrade                = bool<br>    disk_size                   = optional(number)<br>    disk_type                   = optional(string)<br>    image_type                  = optional(string)<br>    strategy                    = optional(string)<br>    max_surge                   = optional(number)<br>    max_unavailable             = optional(number)<br>    node_pool_soak_duration     = optional(string)<br>    batch_soak_duration         = optional(string)<br>    batch_percentage            = optional(number)<br>    batch_node_count            = optional(number)<br>    enable_secure_boot          = optional(bool, false)<br>    enable_integrity_monitoring = optional(bool, true)<br>  })</pre> | <pre>{<br>  "auto_repair": true,<br>  "auto_upgrade": true,<br>  "autoscaling_profile": "BALANCED",<br>  "disk_size": 100,<br>  "disk_type": "pd-standard",<br>  "enable_integrity_monitoring": true,<br>  "enable_secure_boot": false,<br>  "enabled": false,<br>  "gpu_resources": [],<br>  "image_type": "COS_CONTAINERD",<br>  "max_cpu_cores": 0,<br>  "max_memory_gb": 0,<br>  "min_cpu_cores": 0,<br>  "min_memory_gb": 0<br>}</pre> | no |
| cluster\_dns\_domain | The suffix used for all cluster service records. | `string` | `""` | no |
| cluster\_dns\_provider | Which in-cluster DNS provider should be used. PROVIDER\_UNSPECIFIED (default) or PLATFORM\_DEFAULT or CLOUD\_DNS. | `string` | `"PROVIDER_UNSPECIFIED"` | no |
| cluster\_dns\_scope | The scope of access to cluster DNS records. DNS\_SCOPE\_UNSPECIFIED (default) or CLUSTER\_SCOPE or VPC\_SCOPE. | `string` | `"DNS_SCOPE_UNSPECIFIED"` | no |
| cluster\_ipv4\_cidr | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | `string` | `null` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | `{}` | no |
| cluster\_telemetry\_type | Available options include ENABLED, DISABLED, and SYSTEM\_ONLY | `string` | `null` | no |
| config\_connector | Whether ConfigConnector is enabled for this cluster. | `bool` | `false` | no |
| configure\_ip\_masq | Enables the installation of ip masquerading, which is usually no longer required when using aliasied IP addresses. IP masquerading uses a kubectl call, so when you have a private cluster, you will need access to the API server. | `bool` | `false` | no |
| create\_service\_account | Defines if service account specified to run nodes should be created. | `bool` | `true` | no |
| database\_encryption | Application-layer Secrets Encryption settings. The object format is {state = string, key\_name = string}. Valid values of state are: "ENCRYPTED"; "DECRYPTED". key\_name is the name of a CloudKMS key. | `list(object({ state = string, key_name = string }))` | <pre>[<br>  {<br>    "key_name": "",<br>    "state": "DECRYPTED"<br>  }<br>]</pre> | no |
| datapath\_provider | The desired datapath provider for this cluster. By default, `DATAPATH_PROVIDER_UNSPECIFIED` enables the IPTables-based kube-proxy implementation. `ADVANCED_DATAPATH` enables Dataplane-V2 feature. | `string` | `"DATAPATH_PROVIDER_UNSPECIFIED"` | no |
| default\_max\_pods\_per\_node | The maximum number of pods to schedule per node | `number` | `110` | no |
| deletion\_protection | Whether or not to allow Terraform to destroy the cluster. | `bool` | `true` | no |
| deploy\_using\_private\_endpoint | A toggle for Terraform and kubectl to connect to the master's internal IP address during deployment. | `bool` | `false` | no |
| description | The description of the cluster | `string` | `""` | no |
| disable\_default\_snat | Whether to disable the default SNAT to support the private use of public IP addresses | `bool` | `false` | no |
| disable\_legacy\_metadata\_endpoints | Disable the /0.1/ and /v1beta1/ metadata server endpoints on the node. Changing this value will cause all node pools to be recreated. | `bool` | `true` | no |
| dns\_cache | The status of the NodeLocal DNSCache addon. | `bool` | `false` | no |
| enable\_binary\_authorization | Enable BinAuthZ Admission controller | `bool` | `false` | no |
| enable\_cilium\_clusterwide\_network\_policy | Enable Cilium Cluster Wide Network Policies on the cluster | `bool` | `false` | no |
| enable\_confidential\_nodes | An optional flag to enable confidential node config. | `bool` | `false` | no |
| enable\_cost\_allocation | Enables Cost Allocation Feature and the cluster name and namespace of your GKE workloads appear in the labels field of the billing export to BigQuery | `bool` | `false` | no |
| enable\_default\_node\_pools\_metadata | Whether to enable the default node pools metadata key-value pairs such as `cluster_name` and `node_pool` | `bool` | `true` | no |
| enable\_fqdn\_network\_policy | Enable FQDN Network Policies on the cluster | `bool` | `null` | no |
| enable\_gcfs | Enable image streaming on cluster level. | `bool` | `false` | no |
| enable\_identity\_service | (Optional) Enable the Identity Service component, which allows customers to use external identity providers with the K8S API. | `bool` | `false` | no |
| enable\_intranode\_visibility | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `false` | no |
| enable\_kubernetes\_alpha | Whether to enable Kubernetes Alpha features for this cluster. Note that when this option is enabled, the cluster cannot be upgraded and will be automatically deleted after 30 days. | `bool` | `false` | no |
| enable\_l4\_ilb\_subsetting | Enable L4 ILB Subsetting on the cluster | `bool` | `false` | no |
| enable\_mesh\_certificates | Controls the issuance of workload mTLS certificates. When enabled the GKE Workload Identity Certificates controller and node agent will be deployed in the cluster. Requires Workload Identity. | `bool` | `false` | no |
| enable\_network\_egress\_export | Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic. | `bool` | `false` | no |
| enable\_pod\_security\_policy | enabled - Enable the PodSecurityPolicy controller for this cluster. If enabled, pods must be valid under a PodSecurityPolicy to be created. Pod Security Policy was removed from GKE clusters with version >= 1.25.0. | `bool` | `false` | no |
| enable\_private\_endpoint | Whether the master's internal IP address is used as the cluster endpoint | `bool` | `false` | no |
| enable\_private\_nodes | Whether nodes have internal IP addresses only | `bool` | `true` | no |
| enable\_resource\_consumption\_export | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. | `bool` | `true` | no |
| enable\_secret\_manager\_addon | Enable the Secret Manager add-on for this cluster | `bool` | `false` | no |
| enable\_shielded\_nodes | Enable Shielded Nodes features on all nodes in this cluster | `bool` | `true` | no |
| enable\_tpu | Enable Cloud TPU resources in the cluster. WARNING: changing this after cluster creation is destructive! | `bool` | `false` | no |
| enable\_vertical\_pod\_autoscaling | Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it | `bool` | `false` | no |
| filestore\_csi\_driver | The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes | `bool` | `false` | no |
| firewall\_inbound\_ports | List of TCP ports for admission/webhook controllers. Either flag `add_master_webhook_firewall_rules` or `add_cluster_firewall_rules` (also adds egress rules) must be set to `true` for inbound-ports firewall rules to be applied. | `list(string)` | <pre>[<br>  "8443",<br>  "9443",<br>  "15017"<br>]</pre> | no |
| firewall\_priority | Priority rule for firewall rules | `number` | `1000` | no |
| fleet\_project | (Optional) Register the cluster with the fleet in this project. | `string` | `null` | no |
| fleet\_project\_grant\_service\_agent | (Optional) Grant the fleet project service identity the `roles/gkehub.serviceAgent` and `roles/gkehub.crossProjectServiceAgent` roles. | `bool` | `false` | no |
| gateway\_api\_channel | The gateway api channel of this cluster. Accepted values are `CHANNEL_STANDARD` and `CHANNEL_DISABLED`. | `string` | `null` | no |
| gce\_pd\_csi\_driver | Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. | `bool` | `true` | no |
| gcp\_public\_cidrs\_access\_enabled | Allow access through Google Cloud public IP addresses | `bool` | `null` | no |
| gcs\_fuse\_csi\_driver | Whether GCE FUSE CSI driver is enabled for this cluster. | `bool` | `false` | no |
| gke\_backup\_agent\_config | Whether Backup for GKE agent is enabled for this cluster. | `bool` | `false` | no |
| grant\_registry\_access | Grants created cluster-specific service account storage.objectViewer and artifactregistry.reader roles. | `bool` | `false` | no |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Enable httpload balancer addon | `bool` | `true` | no |
| identity\_namespace | The workload pool to attach all Kubernetes service accounts to. (Default value of `enabled` automatically sets project-based pool `[project_id].svc.id.goog`) | `string` | `"enabled"` | no |
| initial\_node\_count | The number of nodes to create in this cluster's default node pool. | `number` | `0` | no |
| insecure\_kubelet\_readonly\_port\_enabled | Whether or not to set `insecure_kubelet_readonly_port_enabled` for node pool defaults and autopilot clusters. Note: this can be set at the node pool level separately within `node_pools`. | `bool` | `null` | no |
| ip\_masq\_link\_local | Whether to masquerade traffic to the link-local prefix (169.254.0.0/16). | `bool` | `false` | no |
| ip\_masq\_resync\_interval | The interval at which the agent attempts to sync its ConfigMap file from the disk. | `string` | `"60s"` | no |
| ip\_range\_pods | The _name_ of the secondary subnet ip range to use for pods | `string` | n/a | yes |
| ip\_range\_services | The _name_ of the secondary subnet range to use for services | `string` | n/a | yes |
| issue\_client\_certificate | Issues a client certificate to authenticate to the cluster endpoint. To maximize the security of your cluster, leave this option disabled. Client certificates don't automatically rotate and aren't easily revocable. WARNING: changing this after cluster creation is destructive! | `bool` | `false` | no |
| istio | (Beta) Enable Istio addon | `bool` | `false` | no |
| istio\_auth | (Beta) The authentication type between services in Istio. | `string` | `"AUTH_MUTUAL_TLS"` | no |
| kalm\_config | (Beta) Whether KALM is enabled for this cluster. | `bool` | `false` | no |
| kubernetes\_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | `string` | `"latest"` | no |
| logging\_enabled\_components | List of services to monitor: SYSTEM\_COMPONENTS, APISERVER, CONTROLLER\_MANAGER, KCP\_CONNECTION, KCP\_SSHD, SCHEDULER, and WORKLOADS. Empty list is default GKE configuration. | `list(string)` | `[]` | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| logging\_variant | (Optional) The type of logging agent that is deployed by default for newly created node pools in the cluster. Valid values include DEFAULT and MAX\_THROUGHPUT. | `string` | `null` | no |
| maintenance\_end\_time | Time window specified for recurring maintenance operations in RFC3339 format | `string` | `""` | no |
| maintenance\_exclusions | List of maintenance exclusions. A cluster can have up to three | `list(object({ name = string, start_time = string, end_time = string, exclusion_scope = string }))` | `[]` | no |
| maintenance\_recurrence | Frequency of the recurring maintenance window in RFC5545 format. | `string` | `""` | no |
| maintenance\_start\_time | Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| master\_global\_access\_enabled | Whether the cluster master is accessible globally (from any region) or only within the same region as the private endpoint. | `bool` | `true` | no |
| master\_ipv4\_cidr\_block | (Optional) The IP range in CIDR notation to use for the hosted master network. | `string` | `null` | no |
| monitoring\_enable\_managed\_prometheus | Configuration for Managed Service for Prometheus. Whether or not the managed collection is enabled. | `bool` | `null` | no |
| monitoring\_enable\_observability\_metrics | Whether or not the advanced datapath metrics are enabled. | `bool` | `false` | no |
| monitoring\_enable\_observability\_relay | Whether or not the advanced datapath relay is enabled. | `bool` | `false` | no |
| monitoring\_enabled\_components | List of services to monitor: SYSTEM\_COMPONENTS, APISERVER, SCHEDULER, CONTROLLER\_MANAGER, STORAGE, HPA, POD, DAEMONSET, DEPLOYMENT, STATEFULSET, KUBELET, CADVISOR and DCGM. In beta provider, WORKLOADS is supported on top of those 12 values. (WORKLOADS is deprecated and removed in GKE 1.24.) KUBELET and CADVISOR are only supported in GKE 1.29.3-gke.1093000 and above. Empty list is default GKE configuration. | `list(string)` | `[]` | no |
| monitoring\_metric\_writer\_role | The monitoring metrics writer role to assign to the GKE node service account | `string` | `"roles/monitoring.metricWriter"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| name | The name of the cluster (required) | `string` | n/a | yes |
| network | The VPC network to host the cluster in (required) | `string` | n/a | yes |
| network\_policy | Enable network policy addon | `bool` | `false` | no |
| network\_policy\_provider | The network policy provider. | `string` | `"CALICO"` | no |
| network\_project\_id | The project ID of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| network\_tags | (Optional) - List of network tags applied to auto-provisioned node pools. | `list(string)` | `[]` | no |
| node\_metadata | Specifies how node metadata is exposed to the workload running on the node | `string` | `"GKE_METADATA"` | no |
| node\_pools | List of maps containing node pools | `list(map(any))` | <pre>[<br>  {<br>    "name": "default-node-pool"<br>  }<br>]</pre> | no |
| node\_pools\_cgroup\_mode | Map of strings containing cgroup node config by node-pool name | `map(string)` | <pre>{<br>  "all": "",<br>  "default-node-pool": ""<br>}</pre> | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_linux\_node\_configs\_sysctls | Map of maps containing linux node config sysctls by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_metadata | Map of maps containing node metadata by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_oauth\_scopes | Map of lists containing node oauth scopes by node-pool name | `map(list(string))` | <pre>{<br>  "all": [<br>    "https://www.googleapis.com/auth/cloud-platform"<br>  ],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_resource\_labels | Map of maps containing resource labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_resource\_manager\_tags | Map of maps containing resource manager tags by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_tags | Map of lists containing node network tags by node-pool name | `map(list(string))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_taints | Map of lists containing node taints by node-pool name | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| non\_masquerade\_cidrs | List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading. | `list(string)` | <pre>[<br>  "10.0.0.0/8",<br>  "172.16.0.0/12",<br>  "192.168.0.0/16"<br>]</pre> | no |
| notification\_config\_topic | The desired Pub/Sub topic to which notifications will be sent by GKE. Format is projects/{project}/topics/{topic}. | `string` | `""` | no |
| notification\_filter\_event\_type | Choose what type of notifications you want to receive. If no filters are applied, you'll receive all notification types. Can be used to filter what notifications are sent. Accepted values are UPGRADE\_AVAILABLE\_EVENT, UPGRADE\_EVENT, and SECURITY\_BULLETIN\_EVENT. | `list(string)` | `[]` | no |
| private\_endpoint\_subnetwork | The subnetwork to use for the hosted master network. | `string` | `null` | no |
| project\_id | The project ID to host the cluster in (required) | `string` | n/a | yes |
| ray\_operator\_config | The Ray Operator Addon configuration for this cluster. | <pre>object({<br>    enabled            = bool<br>    logging_enabled    = optional(bool, false)<br>    monitoring_enabled = optional(bool, false)<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "logging_enabled": false,<br>  "monitoring_enabled": false<br>}</pre> | no |
| region | The region to host the cluster in (optional if zonal cluster / required if regional) | `string` | `null` | no |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |
| registry\_project\_ids | Projects holding Google Container Registries. If empty, we use the cluster project. If a service account is created and the `grant_registry_access` variable is set to `true`, the `storage.objectViewer` and `artifactregsitry.reader` roles are assigned on these projects. | `list(string)` | `[]` | no |
| release\_channel | The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"REGULAR"` | no |
| remove\_default\_node\_pool | Remove default node pool while setting up the cluster | `bool` | `false` | no |
| resource\_usage\_export\_dataset\_id | The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export. | `string` | `""` | no |
| sandbox\_enabled | (Beta) Enable GKE Sandbox (Do not forget to set `image_type` = `COS_CONTAINERD` to use it). | `bool` | `false` | no |
| security\_posture\_mode | Security posture mode. Accepted values are `DISABLED` and `BASIC`. Defaults to `DISABLED`. | `string` | `"DISABLED"` | no |
| security\_posture\_vulnerability\_mode | Security posture vulnerability mode. Accepted values are `VULNERABILITY_DISABLED`, `VULNERABILITY_BASIC`, and `VULNERABILITY_ENTERPRISE`. Defaults to `VULNERABILITY_DISABLED`. | `string` | `"VULNERABILITY_DISABLED"` | no |
| service\_account | The service account to run nodes as if not overridden in `node_pools`. The create\_service\_account variable default value (true) will cause a cluster-specific service account to be created. This service account should already exists and it will be used by the node pools. If you wish to only override the service account name, you can use service\_account\_name variable. | `string` | `""` | no |
| service\_account\_name | The name of the service account that will be created if create\_service\_account is true. If you wish to use an existing service account, use service\_account variable. | `string` | `""` | no |
| service\_external\_ips | Whether external ips specified by a service will be allowed in this cluster | `bool` | `false` | no |
| shadow\_firewall\_rules\_log\_config | The log\_config for shadow firewall rules. You can set this variable to `null` to disable logging. | <pre>object({<br>    metadata = string<br>  })</pre> | <pre>{<br>  "metadata": "INCLUDE_ALL_METADATA"<br>}</pre> | no |
| shadow\_firewall\_rules\_priority | The firewall priority of GKE shadow firewall rules. The priority should be less than default firewall, which is 1000. | `number` | `999` | no |
| stack\_type | The stack type to use for this cluster. Either `IPV4` or `IPV4_IPV6`. Defaults to `IPV4`. | `string` | `"IPV4"` | no |
| stateful\_ha | Whether the Stateful HA Addon is enabled for this cluster. | `bool` | `false` | no |
| stub\_domains | Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server | `map(list(string))` | `{}` | no |
| subnetwork | The subnetwork to host the cluster in (required) | `string` | n/a | yes |
| timeouts | Timeout for cluster operations. | `map(string)` | `{}` | no |
| upstream\_nameservers | If specified, the values replace the nameservers taken by default from the node’s /etc/resolv.conf | `list(string)` | `[]` | no |
| windows\_node\_pools | List of maps containing Windows node pools | `list(map(string))` | `[]` | no |
| workload\_config\_audit\_mode | (beta) Sets which mode of auditing should be used for the cluster's workloads. Accepted values are DISABLED, BASIC. | `string` | `"DISABLED"` | no |
| workload\_vulnerability\_mode | (beta) Sets which mode to use for Protect workload vulnerability scanning feature. Accepted values are DISABLED, BASIC. | `string` | `""` | no |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| cloudrun\_enabled | Whether CloudRun enabled |
| cluster\_id | Cluster ID |
| dns\_cache\_enabled | Whether DNS Cache enabled |
| endpoint | Cluster endpoint |
| endpoint\_dns | Cluster endpoint DNS |
| fleet\_membership | Fleet membership (if registered) |
| gateway\_api\_channel | The gateway api channel of this cluster. |
| horizontal\_pod\_autoscaling\_enabled | Whether horizontal pod autoscaling enabled |
| http\_load\_balancing\_enabled | Whether http load balancing enabled |
| identity\_namespace | Workload Identity pool |
| identity\_service\_enabled | Whether Identity Service is enabled |
| instance\_group\_urls | List of GKE generated instance groups |
| intranode\_visibility\_enabled | Whether intra-node visibility is enabled |
| istio\_enabled | Whether Istio is enabled |
| location | Cluster location (region if regional cluster, zone if zonal cluster) |
| logging\_service | Logging service used |
| master\_authorized\_networks\_config | Networks from which access to master is permitted |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation used for the hosted master network |
| master\_version | Current master kubernetes version |
| mesh\_certificates\_config | Mesh certificates configuration |
| min\_master\_version | Minimum master kubernetes version |
| monitoring\_service | Monitoring service used |
| name | Cluster name |
| network\_policy\_enabled | Whether network policy enabled |
| node\_pools\_names | List of node pools names |
| node\_pools\_versions | Node pool versions by node pool name |
| peering\_name | The name of the peering between this cluster and the Google owned VPC. |
| pod\_security\_policy\_enabled | Whether pod security policy is enabled |
| region | Cluster region |
| release\_channel | The release channel of this cluster |
| secret\_manager\_addon\_enabled | Whether Secret Manager add-on is enabled |
| service\_account | The service account to default running nodes as if not overridden in `node_pools`. |
| tpu\_ipv4\_cidr\_block | The IP range in CIDR notation used for the TPUs |
| type | Cluster type (regional / zonal) |
| vertical\_pod\_autoscaling\_enabled | Whether vertical pod autoscaling enabled |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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
| local_ssd_ephemeral_count | The amount of local SSD disks that will be attached to each cluster node and assigned as scratch space as an `emptyDir` volume. If unspecified, ephemeral storage is backed by the cluster node boot disk. | 0 | Optional |
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
| node_count | The number of nodes in the nodepool when autoscaling is false. Otherwise defaults to 1. Only valid for non-autoscaling clusters |  | Required |
| node_locations | The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. Defaults to cluster level node locations if nothing is specified | " " | Optional |
| node_metadata | Options to expose the node metadata to the workload running on the node | | Optional |
| preemptible | A boolean that represents whether or not the underlying node VMs are preemptible | false | Optional |
| spot | A boolean that represents whether the underlying node VMs are spot | false | Optional |
| sandbox_type | Sandbox to use for pods in the node pool | | Required |
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
- [Terraform Provider for GCP Beta][terraform-provider-google-beta] v6.14+
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

[terraform-provider-google-beta]: https://github.com/terraform-providers/terraform-provider-google-beta
[12.3.0]: https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/12.3.0
[terraform-0.13-upgrade]: https://www.terraform.io/upgrade-guides/0-13.html
[terraform-1.3-upgrade]: https://developer.hashicorp.com/terraform/language/v1.3.x/upgrade-guides
