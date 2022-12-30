# Creating Private GKE Clusters

To create a private GKE cluster, you can use one of the [private submodules](../modules).

Note that a private cluster is inherently more restricted and greater care must be taken in configuring networking ingress/egress.

## Private Cluster Endpoints
When creating a [private cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters), nodes are provisioned with private IPs.
The Kubernetes master endpoint is also [locked down](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#access_to_the_cluster_endpoints), which affects these module features:
- `configure_ip_masq`
- `stub_domains`

If you are *not* using these features, then the module will function normally for private clusters and no special configuration is needed.

If you are using these features with a private cluster, you will need to either:
1. Run Terraform from a VM on the same VPC as your cluster (allowing it to connect to the private endpoint) and set `deploy_using_private_endpoint` to `true`.
2. Enable (beta) [route export functionality](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#master-on-prem-routing) to connect from an on-premise network over a VPN or Interconnect.
3. Include the external IP of your Terraform deployer in the `master_authorized_networks` configuration.
4. Deploy a [bastion host](https://github.com/terraform-google-modules/terraform-google-bastion-host) or [proxy](https://cloud.google.com/solutions/creating-kubernetes-engine-private-clusters-with-net-proxies) in the same VPC as your GKE cluster.

If you are going to isolate your GKE private clusters from internet access you could check [this guide](https://medium.com/google-cloud/completely-private-gke-clusters-with-no-internet-connectivity-945fffae1ccd) and the associated [repo](https://github.com/andreyk-code/no-inet-gke-cluster).

## Discontiguous multi-Pod CIDR
If you are going to use [discontiguous multi-Pod CIDR](https://cloud.google.com/kubernetes-engine/docs/how-to/multi-pod-cidr) it can happen that GKE robot will not update `gke-[cluster-name]-[cluster-hash]-all` and other firewall rules automatically when you add a new node pool (as stated in [documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/multi-pod-cidr#modified_firewall_rule)). You can prevent this from happening, by using a workaround with shadow firewall rules:
```
module "gke" {
  ...
  add_shadow_firewall_rules  = true
  shadow_firewall_rules_log_config = null # to save some $ on logs
}
```

## Troubleshooting

### Master Authorized Network
When creating a private cluster with a [private endpoint](https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks#benefits_with_private_clusters) (`enable_private_endpoint = true`),
your cluster will **not** have a publicly addressable endpoint.

When using this setting, any CIDR ranges listed in the `master_authorized_networks` configuration *must* come from your private IP space.
If you include a CIDR block outside your private space, you might see this error:

```
Error: Error waiting for creating GKE cluster: Invalid master authorized networks: network "73.89.231.174/32" is not a reserved network, which is required for private endpoints.

  on .terraform/modules/gke-cluster-dev.gke/terraform-google-kubernetes-engine-9.2.0/modules/beta-private-cluster/cluster.tf line 22, in resource "google_container_cluster" "primary":
  22: resource "google_container_cluster" "primary" {
```

To resolve this error, update your configuration to either:

* Enable a public endpoint (with `enable_private_endpoint = false`)
* Update your `master_authorized_networks` configuration to only use CIDR blocks from your private IP space.
