# Creating Private GKE Clusters

To create a private GKE cluster, you can use one of the [private submodules](../modules).

Note that a private cluster is inherently more restricted and greater care must be taken in configuring networking ingress/egress.

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
