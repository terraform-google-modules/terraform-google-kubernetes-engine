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
