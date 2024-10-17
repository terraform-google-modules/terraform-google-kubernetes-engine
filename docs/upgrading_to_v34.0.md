# Upgrading to v34.0

The v34.0 release of _kubernetes-engine_ is a backwards incompatible release.

### safer-cluster modules: Added create_service_account variable

This only affects users of the `safer-cluster` modules that have set `var.compute_engine_service_account` to something other than the default `""`.

A variable `var.create_service_account` was added to the `safer-cluster` modules that when explicitly set to `false` avoids the following error withing the `private-cluster` modules:

```sh
Error: Invalid count argument

  on .terraform/modules/gke_cluster.gke/modules/beta-private-cluster/sa.tf line 35, in resource "random_string" "cluster_service_account_suffix":
  35:   count   = var.create_service_account && var.service_account_name == "" ? 1 : 0

The "count" value depends on resource attributes that cannot be determined
until apply, so Terraform cannot predict how many instances will be created.
To work around this, use the -target argument to first apply only the
resources that the count depends on.
```

This seems to happen if `var.compute_engine_service_account` is passed in, and the externally created service account is being created at the same time, so the name/email is not computed yet:

```terraform
resource "google_service_account" "cluster_service_account" {
  project      = var.project_id
  account_id   = "tf-gke-${var.cluster_name}-${random_string.cluster_service_account_suffix.result}"
  display_name = "Terraform-managed service account for cluster ${var.cluster_name}"
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/safer-cluster"
  version = "~> 33.0"

  project_id  = var.project_id
  name        = var.cluster_name

  create_service_account         = false
  compute_engine_service_account = google_service_account.cluster_service_account.email
}
```

By explicitly passing a `var.create_service_account = false` it short circuits the calculations dependent on `var.service_account_name`:

```terraform
resource "random_string" "cluster_service_account_suffix" {
  count   = var.create_service_account && var.service_account_name == "" ? 1 : 0
  upper   = false
  lower   = true
  special = false
  length  = 4
}
```
