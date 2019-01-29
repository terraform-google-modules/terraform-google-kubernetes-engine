# Upgrading to terraform-google-kubernetes-engine v1.0

The v1.0 release of terraform-google-kubernetes-engine is a backwards incompatible release.

## Migration Instructions

### Re-enabling Kubernetes Basic Authentication

Starting with version 1.12, clusters will have basic authentication and client certificate issuance disabled by default in GKE. In previous versions of *terraform-google-kubernetes-engine* basic auth was silently enabled. It is now disabled by default.

**Re-enabling Kubernetes basic authentication:**

**Note:** enabling basic auth will cause terraform to store your basic auth credentials in state file. It is important to use a backend that supports encryption at rest. [Read more](https://www.terraform.io/docs/state/sensitive-data.html)

```hcl
module "enabling-basic-auth" {
  source = "terraform-google-modules/kubernetes-engine/google"
  project_id        = "${var.project_id}"
  name              = "cluster-with-basic-auth"

  enable_basic_auth = "true"
  basic_auth_username = "admin"
  basic_auth_password = "s3crets!"

  regional          = "true"
  region            = "${var.region}"
  network           = "${var.network}"
  subnetwork        = "${var.subnetwork}"
  ip_range_pods     = "${var.ip_range_pods}"
  ip_range_services = "${var.ip_range_services}"
  service_account   = "${var.compute_engine_service_account}"
}
```
