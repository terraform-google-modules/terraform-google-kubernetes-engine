# Deploying GKE on alternate GCP universes

This guide describes how to deploy GKE Autopilot using this module on **alternate GCP universes**—environments where Google Cloud APIs behave differently from standard public GCP and where the options described below are required.

The following submodules support these environments with the same variables and behavior:

- `modules/beta-autopilot-private-cluster`
- `modules/beta-autopilot-public-cluster`

## What is a GCP universe?

A **GCP universe** (sometimes called an *alternate* or *restricted* universe) is a distinct Google Cloud environment that uses compatible APIs but with different semantics or constraints. Examples include:

- **Sovereign clouds** (e.g. S3ns Cloud de Confiance, or other nationally regulated clouds)
- **Restricted or compliance-specific** regions
- **Air-gapped or isolated** environments

In such universes, the Container API and Compute API may accept different location or zone formats, and Workload Identity may use a different pool format. The module options below allow the same Terraform code to work in both standard GCP and these alternate universes.

## Why these options are needed

In some GCP universes:

1. **Container API** may only accept **region-level** location for the server config/versions endpoint, not zone names. Using a zone can result in: `Location "<zone>" does not exist`.

2. **Compute API** may return zone names that the **GKE API** does not accept for `node_locations` (e.g. the region name as the only "zone"), leading to: `Invalid zone provided: <value>`.

3. **Workload Identity** may require a different pool format (e.g. `PROJECT.<suffix>.svc.id.goog` instead of `PROJECT.svc.id.goog`), and the API may require a single fixed value per environment.

## Module changes for compatibility

The module supports alternate GCP universes via:

- **Regional cluster version lookup:** When creating a regional cluster, the zone-level container engine versions data source uses the **region** as location instead of a zone, so the Container API is only queried with the region.
- **Optional API-default node locations:** The variable **`node_locations_use_api_default`** (default `false`) lets you omit explicit `node_locations` when no zones are provided. The GKE API then chooses the default zones for the region. Set to `true` when your universe’s Compute zones do not match GKE API expectations.

Default behavior for standard GCP is unchanged.

## Example

```hcl
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"  # or beta-autopilot-public-cluster

  project_id = "your-project"   # may use a provider-specific prefix in some universes (e.g. "s3ns:your-project")
  name       = "gke-autopilot-prod"
  region     = "your-region"

  node_locations_use_api_default = true
  identity_namespace             = "your-project.svc.id.goog"   # use the exact workload pool required by your universe

  network        = "your-vpc"
  subnetwork     = "your-subnet"
  ip_range_pods  = "your-pods-range"
  # ... other required variables
}
```

Notes:

- Do **not** set `zones` when using `node_locations_use_api_default = true` for a regional cluster; the API will choose zones.
- Set `identity_namespace` to the exact workload pool value required by your GCP universe (e.g. in S3ns Cloud de Confiance, `my-project.s3ns.svc.id.goog` instead of `my-project.svc.id.goog`).

## References

For one example of an alternate universe, see [S3ns Cloud de Confiance](https://www.s3ns.io) (e.g. [S3ns GKE documentation](https://documentation.s3ns.fr/kubernetes-engine/docs)).
