# Upgrading to v2.0

The v2.0 release of *kubernetes-engine* is a backwards incompatible
release.

## Migration Instructions

### Using Default Service Account

In previous versions of *kubernetes-engine*, the default service
account of the hosting project was used by the Node VMs if no other
service account was explicitly configured. A dedicated service account
is now created for the Node VMs if no other service account is
explicitly configured.

The default service account of the hosting project can still be used if
desired, as shown in the following example:

```hcl
module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 2.1"

  billing_account = "XXXXXX-YYYYYY-ZZZZZZ"
  name            = "example"
  org_id          = "XXXXXXXXXXXX"
}

module "kubernetes_engine" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 2.0"

  ip_range_pods     = "secondary-subnet-ip-range-pods"
  ip_range_services = "secondary-subnet-ip-range-services"
  name              = "example"
  network           = "cluster-network"
  project_id        = "${module.project_factory.project_id}"
  region            = "northamerica-northeast"
  subnetwork        = "cluster-subnetwork"

  service_account = "${module.project_factory.service_account_email}"
}
```

### Enabling Kubernetes Basic Authentication

Starting with GKE v1.12, clusters will by default disable the Basic
Authentication method of authenticating. In previous versions of
*kubernetes-engine*, Basic Authentication was enabled and configured
with the username `"admin"` and an automatically generated password if
the managed version of Kubernetes was less than v1.12.
Basic Authentication is now requires credentials to be provided to be
enabled.

Using Basic Authentication causes Terraform to store the credentials in
a state file. It is important to use a Terraform Backend which supports
encryption at rest, like the [GCS Backend][gcs-backend]. The
[Sensitive Data in State article][sensitive-data] provides more context
and recommendations on how to handle scenarios like this.

```hcl
terraform {
  backend "gcs" {
    bucket = "terraform-state"
  }
}

module "enabling-basic-auth" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 2.0"

  project_id = "${var.project_id}"
  name       = "cluster-with-basic-auth"

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

### Enabling Kubernetes Client Certificate

Starting with GKE v1.12, clusters will disable by default the client
certificate method of authenticating. In previous versions
of *kubernetes-engine*, client certificate authentication was enabled
if the managed version of Kubernetes was less than v1.12. Client
certificate authentication must now be explicitly enabled.

```hcl
module "enabling-client-certificate" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 2.0"

  project_id = "${var.project_id}"
  name       = "cluster-with-client-certificate"

  issue_client_certificate = "true"

  regional          = "true"
  region            = "${var.region}"
  network           = "${var.network}"
  subnetwork        = "${var.subnetwork}"
  ip_range_pods     = "${var.ip_range_pods}"
  ip_range_services = "${var.ip_range_services}"
  service_account   = "${var.compute_engine_service_account}"
}
```

[gsc-backend]: https://www.terraform.io/docs/backends/types/gcs.html
[sensitive-data]: https://www.terraform.io/docs/state/sensitive-data.html
