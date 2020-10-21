# Binary Authorization Infrastructure

This module creates the infrastructure and Attestors necessary to generate attestations on image digests.

## Compatibility/Requirements

* GCP Project ID where the project has an active billing account associated with it
* Terraform version 0.12+
* Google Kubernetes Engine cluster with "Binary Authorization" enabled

## Usage

```tf
# Create a Key Ring
resource "google_kms_key_ring" "keyring" {
  name     = "my-example-attestor-key-ring"
  location = var.keyring-region
  lifecycle {
    prevent_destroy = false
  }
}

# Create Quality Assurance attestor
module "quality-attestor" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/binary-authorization"

  attestor-name = "quality-assurance"
  keyring-id    = google_kms_key_ring.keyring.id
}

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attestor-name | Name of the attestor | `string` | n/a | yes |
| crypto-algorithm | Algorithm used for the async signing keys | `string` | `"RSA_SIGN_PKCS1_4096_SHA512"` | no |
| disable\_dependent\_services | Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_dependent_services | `bool` | `false` | no |
| disable\_services\_on\_destroy | Whether project services will be disabled when the resources are destroyed. https://www.terraform.io/docs/providers/google/r/google_project_service.html#disable_on_destroy | `bool` | `false` | no |
| keyring-id | Keyring ID to attach attestor keys | `string` | n/a | yes |
| project\_id | Project ID to apply services into | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| attestor | Name of the built attestor |
| key | Name of the Key created for the attestor |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Next Steps

After building the Attestors, Attestations can be associated with image digests.

This module does not include a Binary Authorization policy for a cluster.  A sample policy implemented as Dry-Run/Log-Only using our "quality-assurance" Attestor could look like this:

```tf
resource "google_binary_authorization_policy" "policy" {

  admission_whitelist_patterns {
    name_pattern = "gcr.io/${var.project_id}/*" # Enable local project GCR
  }

  global_policy_evaluation_mode = "ENABLE"

  # Production ready (all attestors required)
  default_admission_rule {
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "DRYRUN_AUDIT_LOG_ONLY"
    require_attestations_by = [
      module.quality-attestor.attestor  # Our Attestor
    ]
  }
}
```
