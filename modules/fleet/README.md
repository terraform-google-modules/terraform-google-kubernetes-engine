
# Terraform Kubernetes Engine Fleet submodule

GKE submodule to manage GKE's fleets

With the two mandatory parameters, the module will create a fleet on the specified project. it requires `gkehub.googleapis.com` api only.
The other parameters are Anthos service features. So, if you set or enable any of them, the `anthos.googleapis.com` api will be enabled.

## Usage

```tf
module "hub" {
  source           = "terraform-google-modules/kubernetes-engine/google//modules/fleet"

  project_id       = "fleet-host-project"
  display_name     = "GKE Fleet - Staging"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [google_gke_hub_fleet.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gke_hub_fleet) | resource |
| [google_project_service.anthos](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.gkehub](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_binary_authorization_evaluation_mode"></a> [binary\_authorization\_evaluation\_mode](#input\_binary\_authorization\_evaluation\_mode) | Mode of operation for binauthz policy evaluation. Set to null to omit the attribute and use provider/API default if the block is rendered. Possible values: "DISABLED", "PROJECT\_SINGLETON\_POLICY\_ENFORCE". | `string` | `"DISABLED"` | no |
| <a name="input_binary_authorization_policy_bindings"></a> [binary\_authorization\_policy\_bindings](#input\_binary\_authorization\_policy\_bindings) | A list of binauthz policy bindings. Each binding has a 'name' attribute. | <pre>list(object({<br/>    name = string # Name is technically optional in API, but required for a useful binding here.<br/>  }))</pre> | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | A user-assigned display name of the Fleet. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which the Fleet resource belongs. If it is not provided, the provider project is used. | `string` | n/a | yes |
| <a name="input_security_posture_mode"></a> [security\_posture\_mode](#input\_security\_posture\_mode) | Sets the mode for Security Posture features on the cluster. Set to null to omit the attribute. Possible values: "DISABLED", "BASIC", "ENTERPRISE". | `string` | `"DISABLED"` | no |
| <a name="input_security_posture_vulnerability_mode"></a> [security\_posture\_vulnerability\_mode](#input\_security\_posture\_vulnerability\_mode) | Sets the mode for Vulnerability Scanning. Set to null to omit the attribute. Possible values: "VULNERABILITY\_DISABLED", "VULNERABILITY\_BASIC", "VULNERABILITY\_ENTERPRISE". | `string` | `"VULNERABILITY_DISABLED"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fleet_id"></a> [fleet\_id](#output\_fleet\_id) | the Fleet identifier |
| <a name="output_fleet_state"></a> [fleet\_state](#output\_fleet\_state) | The state of the fleet resource |
| <a name="output_fleet_uid"></a> [fleet\_uid](#output\_fleet\_uid) | Unique UID across all Fleet resources |
<!-- END_TF_DOCS -->
