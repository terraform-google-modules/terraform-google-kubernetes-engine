# Safer Cluster: How to setup a GKE Kubernetes cluster with reduced exposure

This module defines an opinionated setup of GKE
cluster. We outline project configurations, cluster settings, and basic K8s
objects that permit a safer-than-default configuration.

## Module Usage

The module fixes a set of parameters to values suggested in the
[GKE hardening guide](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster),
the CIS framework, and other best practices.

The motivation for each setting, and its relation to harderning guides or other recommendations
is outline in `main.tf` as comments over individual settings. When security-relevant settings
are available for configuration, recommendations on their settings are documented in the `variables.tf` file.

## Project Setup and Cloud IAM policy for GKE

### Applications and Clusters

-   Different applications that access data with different sensitivity and do
    not need to communicate with each other (e.g., dev and prod instances of the
    same application) should be placed in different clusters.

    -   This approach will limit the blast radius of errors. An security problem
        in dev shouldn't impact production data.

-   If applications need to communicate (e.g., a frontend system calling
    a backend), we suggest placing the two applications in the same cluster, in
    different namespaces.

    -   Placing them in the same cluster will provide fast network
        communication, and the different namespaces will be configured to
        provide some administrative isolation. Istio will be used to encrypt and
        control communication between applications.

-   We suggest to store user or business data persistently in managed storage
    services that are inventoried and controlled by centralized teams.
    (e.g., GCP storage services within a GCP organization).

    -   Storing user or business data securely requires satisfying a large set of
        requirements, such as data inventory, which might be harder to satisfy at
        scale when data is stored opaquely within a cluster. Services like Cloud
        Asset Inventory provide centralized teams ability to enumerate data stores.

### Project Setup

We suggest a GKE setup composed of multiple projects to separate responsibilities
between cluster operators, which need to administer the cluster; and product
developers, which mostly just want to deploy and debug applications.

-   *Cluster Projects (`project_id`):* GKE clusters storing sensitive data should have their
    own projects, so that they can be administered independently (e.g., dev cluster;
    production clusters; staging clusters should go in different projects.)

-   *Shared GCR projects (`registry_project_ids`):* all clusters can share the same
    GCR projects.

    -   Easier to share images between environments. The same image could be
        progressively rolled-out in dev, staging, and then production.
    -   Easier to manage service account permissions: GCR requires authorizing
        service accounts to access certain buckets, which are created only after
        images are published. When the only service run by the project is GCR,
        we can safely give project-wide read permissions to all buckets.

-   (optional) *Data Projects:* When the same cluster is shared by different
    applications managed by different teams, we suggest separating the data for
    each application by placing storage resources for each team in different
    projects (e.g., a Spanner instance for application A in one project, GCS
    bucket for application B in a different project).

    -   This permits to control administrative access to the data more tightly,
        as Cloud IAM policies for accessing the data can be managed by each
        application team, rather than the team managing the cluster
        infrastructure.

Exception to such a setup:

-   When not using Shared VPCs, resources that require direct network connectivity
    (e.g., a Cloud SQL instance), need to be placed in the same VPC (hence, project)
    as the clusters from which connections are made.

### Google Service Accounts

We use GKE Workload Identity (BETA) to associate a GCP identity to each workload,
and limit the permissions associated with the cluster nodes.

The Safer Cluster setup relies on several service accounts:

-   The module generates a service account to run nodes. Such a service account
    has only permissions of sending logging data, metrics, and downloading containers
    from the given GCR project. The following settings in the module will create
    a service account with the above properties:

```
create_service_account = true
registry_project_ids = [<the project id for your GCR project>]
grant_registry_access = true
```

-   A service account *for each application* running on the cluster (e.g.,
    `myproduct-sa@myproduct-prod.iam.gserviceaccount.com`). These service
    accounts should be associated to the permissions required for running the
    application, such as access to databases.

```
- email: myproduct
  displayName: Google Service Account for containers running in the myproduct k8s namespace
  policy:
    # GKE workload identity authorization. This authorizes the Kubernetes Service Account
    # myproduct/default from this project's identity namespace to impersonate the service account.
    # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
    bindings:
    - members:
      - serviceAccount:product-prod.svc.id.goog[myproduct/default]
      role: roles/iam.workloadIdentityUser
```

We suggest running different applications in different namespaces within the cluster. Each namespace
should be assigned to its own GCP service account to better define the Cloud IAM permissions required
for the application.

If you are using more than 2 projects in your setup, you can consider creating
the service account in a different project to keep application and
infrastructure separate. For example, service accounts could be created in each team's project,
while the cluster runs in a centrally controlled project.

<section class="zippy">
*Why?*

Separating the permissions associated with the infrastructure GKE nodes and the
application provides a simpler way to scale up the cluster: multiple applications
could be run in the same cluster, and each of them can run with tailored permissions
that limit the impact of compromises.

Such a separation of identities is enabled by a GKE feature called Workload
Identity. The feature provides additional advantages such as a better protection
of the node's metadata server against attackers.

</section>

### Cloud IAM Permissions for the GKE Cluster

We suggest to mainly rely on Kubernetes RBAC to manage access control, and use
Cloud IAM to give users only the ability of configuring `kubectl` credentials.

Engineers operating applications on the cluster should only be assigned the
Cloud IAM permission `roles/container.clusterViewer`. This role allows them to
obtain credentials for the cluster, but provides no further access to the
cluster objects. All cluster objects are protected by RBAC configurations,
defined below.

<section class="zippy">
*Why?*

Both Cloud IAM and RBAC can be used to control access to GKE clusters. Those two
systems are combined as a "OR": an action is authorized if the necessary
permissions are provided by either RBAC _OR_ Cloud IAM

However, Cloud IAM permissions are defined for a project: user get assigned the
same permissions over all clusters and all namespaces within each cluster. Such
a setup makes it hard to separate responsibilities between teams in charge of
managing clusters, and teams in charge of products.

By relying on RBAC instead of Cloud IAM, we have a finer-grained control of the
permissions provided to engineers, and permits to restrict permissions to only
certain namespaces.

</section>

You can add the following binding to the `myproduct-prod` project.

```
- members:
  role: roles/container.clusterViewer`
  - group:<produdct team group>
  - group:<cluster team group>
```

The permissions won't allow engineers to SSH into nodes as part of the regular
development workflow. Such permissions should be granted only to the cluster
team, and used only in case of emergency.

While RBAC permissions should be sufficient for most cases, we also suggest to
create an emergency superuser role that can be used, given a proper
justification, for resolving cases where regular permissions are insufficient.
For simplicity, we suggest using `roles/container.admin` and
`roles/compute.admin`, until more narrow roles can be defined given your usage.

```
- members:
  role: roles/container.admin
  - group:<oncall for cluster tean>
- members:
  role: roles/compute.admin
  - group:<oncall for cluster tean>
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_cluster\_firewall\_rules | Create additional firewall rules | `bool` | `false` | no |
| authenticator\_security\_group | The name of the RBAC security group for use with Google security groups in Kubernetes RBAC. Group name must be in format gke-security-groups@yourdomain.com | `string` | `null` | no |
| cloudrun | (Beta) Enable CloudRun addon | `bool` | `false` | no |
| cluster\_resource\_labels | The GCE resource labels (a map of key/value pairs) to be applied to the cluster | `map(string)` | `{}` | no |
| compute\_engine\_service\_account | Use the given service account for nodes rather than creating a new dedicated service account. | `string` | `""` | no |
| config\_connector | (Beta) Whether ConfigConnector is enabled for this cluster. | `bool` | `false` | no |
| database\_encryption | Application-layer Secrets Encryption settings. The object format is {state = string, key\_name = string}. Valid values of state are: "ENCRYPTED"; "DECRYPTED". key\_name is the name of a CloudKMS key. | `list(object({ state = string, key_name = string }))` | <pre>[<br>  {<br>    "key_name": "",<br>    "state": "DECRYPTED"<br>  }<br>]</pre> | no |
| default\_max\_pods\_per\_node | The maximum number of pods to schedule per node | `number` | `110` | no |
| description | The description of the cluster | `string` | `""` | no |
| disable\_default\_snat | Whether to disable the default SNAT to support the private use of public IP addresses | `bool` | `false` | no |
| dns\_cache | (Beta) The status of the NodeLocal DNSCache addon. | `bool` | `false` | no |
| enable\_intranode\_visibility | Whether Intra-node visibility is enabled for this cluster. This makes same node pod to pod traffic visible for VPC network | `bool` | `false` | no |
| enable\_network\_egress\_export | Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic. | `bool` | `false` | no |
| enable\_pod\_security\_policy | enabled - Enable the PodSecurityPolicy controller for this cluster. If enabled, pods must be valid under a PodSecurityPolicy to be created. | `bool` | `false` | no |
| enable\_private\_endpoint | When true, the cluster's private endpoint is used as the cluster endpoint and access through the public endpoint is disabled. When false, either endpoint can be used. This field only applies to private clusters, when enable\_private\_nodes is true | `bool` | `true` | no |
| enable\_resource\_consumption\_export | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. | `bool` | `true` | no |
| enable\_shielded\_nodes | Enable Shielded Nodes features on all nodes in this cluster. | `bool` | `true` | no |
| enable\_vertical\_pod\_autoscaling | Vertical Pod Autoscaling automatically adjusts the resources of pods controlled by it | `bool` | `false` | no |
| firewall\_inbound\_ports | List of TCP ports for admission/webhook controllers | `list(string)` | <pre>[<br>  "8443",<br>  "9443",<br>  "15017"<br>]</pre> | no |
| firewall\_priority | Priority rule for firewall rules | `number` | `1000` | no |
| gce\_pd\_csi\_driver | (Beta) Whether this cluster should enable the Google Compute Engine Persistent Disk Container Storage Interface (CSI) Driver. | `bool` | `true` | no |
| grant\_registry\_access | Grants created cluster-specific service account storage.objectViewer role. | `bool` | `true` | no |
| horizontal\_pod\_autoscaling | Enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Enable httpload balancer addon. The addon allows whoever can create Ingress objects to expose an application to a public IP. Network policies or Gatekeeper policies should be used to verify that only authorized applications are exposed. | `bool` | `true` | no |
| initial\_node\_count | The number of nodes to create in this cluster's default node pool. | `number` | `0` | no |
| ip\_range\_pods | The _name_ of the secondary subnet ip range to use for pods | `string` | n/a | yes |
| ip\_range\_services | The _name_ of the secondary subnet range to use for services | `string` | n/a | yes |
| istio | (Beta) Enable Istio addon | `bool` | `false` | no |
| istio\_auth | (Beta) The authentication type between services in Istio. | `string` | `"AUTH_MUTUAL_TLS"` | no |
| kubernetes\_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. The module enforces certain minimum versions to ensure that specific features are available. | `string` | `null` | no |
| logging\_service | The logging service that the cluster should write logs to. Available options include logging.googleapis.com, logging.googleapis.com/kubernetes (beta), and none | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_start\_time | Time window specified for daily maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists). | `list(object({ cidr_block = string, display_name = string }))` | `[]` | no |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network | `string` | `"10.0.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics to. Automatically send metrics from pods in the cluster to the Google Cloud Monitoring API. VM metrics will be collected by Google Compute Engine regardless of this setting Available options include monitoring.googleapis.com, monitoring.googleapis.com/kubernetes (beta) and none | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| name | The name of the cluster | `string` | n/a | yes |
| network | The VPC network to host the cluster in | `string` | n/a | yes |
| network\_project\_id | The project ID of the shared VPC's host (for shared vpc support) | `string` | `""` | no |
| node\_pools | List of maps containing node pools | `list(map(string))` | <pre>[<br>  {<br>    "name": "default-node-pool"<br>  }<br>]</pre> | no |
| node\_pools\_labels | Map of maps containing node labels by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_metadata | Map of maps containing node metadata by node-pool name | `map(map(string))` | <pre>{<br>  "all": {},<br>  "default-node-pool": {}<br>}</pre> | no |
| node\_pools\_oauth\_scopes | Map of lists containing node oauth scopes by node-pool name | `map(list(string))` | <pre>{<br>  "all": [<br>    "https://www.googleapis.com/auth/cloud-platform"<br>  ],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_tags | Map of lists containing node network tags by node-pool name | `map(list(string))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_taints | Map of lists containing node taints by node-pool name | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| notification\_config\_topic | The desired Pub/Sub topic to which notifications will be sent by GKE. Format is projects/{project}/topics/{topic}. | `string` | `""` | no |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | n/a | yes |
| regional | Whether is a regional cluster (zonal cluster if set false. WARNING: changing this after cluster creation is destructive!) | `bool` | `true` | no |
| registry\_project\_ids | Projects holding Google Container Registries. If empty, we use the cluster project. If a service account is created and the `grant_registry_access` variable is set to `true`, the `storage.objectViewer` role is assigned on these projects. | `list(string)` | `[]` | no |
| release\_channel | (Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"REGULAR"` | no |
| resource\_usage\_export\_dataset\_id | The dataset id for which network egress metering for this cluster will be enabled. If enabled, a daemonset will be created in the cluster to meter network egress traffic. | `string` | `""` | no |
| sandbox\_enabled | (Beta) Enable GKE Sandbox (Do not forget to set `image_type` = `COS_CONTAINERD` to use it). | `bool` | `false` | no |
| skip\_provisioners | Flag to skip all local-exec provisioners. It breaks `stub_domains` and `upstream_nameservers` variables functionality. | `bool` | `false` | no |
| stub\_domains | Map of stub domains and their resolvers to forward DNS queries for a certain domain to an external DNS server | `map(list(string))` | `{}` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | n/a | yes |
| upstream\_nameservers | If specified, the values replace the nameservers taken by default from the node’s /etc/resolv.conf | `list(string)` | `[]` | no |
| zones | The zones to host the cluster in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | Cluster ca certificate (base64 encoded) |
| cluster\_id | Cluster ID |
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

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
