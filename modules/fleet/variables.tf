variable "project_id" {
  description = "The ID of the project in which the Fleet resource belongs. If it is not provided, the provider project is used."
  type        = string
}

variable "display_name" {
  description = "A user-assigned display name of the Fleet."
  type        = string
}

# variable "manage_default_cluster_config" {
#   description = "Set to true to manage default_cluster_config. If false, the entire default_cluster_config block will be omitted."
#   type        = bool
#   default     = true
# }

# Variables for default_cluster_config.binary_authorization_config
variable "binary_authorization_evaluation_mode" {
  description = "Mode of operation for binauthz policy evaluation. Set to null to omit the attribute and use provider/API default if the block is rendered. Possible values: \"DISABLED\", \"PROJECT_SINGLETON_POLICY_ENFORCE\"."
  type        = string
  default     = "DISABLED" # Provider default
  validation {
    condition     = var.binary_authorization_evaluation_mode == null || can(regex("^(DISABLED|PROJECT_SINGLETON_POLICY_ENFORCE)$", var.binary_authorization_evaluation_mode))
    error_message = "Invalid binary_authorization_evaluation_mode. Must be one of: DISABLED, PROJECT_SINGLETON_POLICY_ENFORCE, or null."
  }
}

variable "binary_authorization_policy_bindings" {
  description = "A list of binauthz policy bindings. Each binding has a 'name' attribute."
  type = list(object({
    name = string # Name is technically optional in API, but required for a useful binding here.
  }))
  default = [] # Default is no bindings
}

# Variables for default_cluster_config.security_posture_config
variable "security_posture_mode" {
  description = "Sets the mode for Security Posture features on the cluster. Set to null to omit the attribute. Possible values: \"DISABLED\", \"BASIC\", \"ENTERPRISE\"."
  type        = string
  default     = "DISABLED" # Matches original and provider default
  validation {
    condition     = var.security_posture_mode == null || can(regex("^(DISABLED|BASIC|ENTERPRISE)$", var.security_posture_mode))
    error_message = "Invalid security_posture_mode. Must be one of: DISABLED, BASIC, ENTERPRISE, or null."
  }
}

variable "security_posture_vulnerability_mode" {
  description = "Sets the mode for Vulnerability Scanning. Set to null to omit the attribute. Possible values: \"VULNERABILITY_DISABLED\", \"VULNERABILITY_BASIC\", \"VULNERABILITY_ENTERPRISE\"."
  type        = string
  default     = "VULNERABILITY_DISABLED" # Matches original and provider default
  validation {
    condition     = var.security_posture_vulnerability_mode == null || can(regex("^(VULNERABILITY_DISABLED|VULNERABILITY_BASIC|VULNERABILITY_ENTERPRISE)$", var.security_posture_vulnerability_mode))
    error_message = "Invalid security_posture_vulnerability_mode. Must be one of: VULNERABILITY_DISABLED, VULNERABILITY_BASIC, VULNERABILITY_ENTERPRISE, or null."
  }
}
