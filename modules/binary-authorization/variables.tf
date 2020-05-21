variable attestor-name {
  type        = string
  description = "Name of the attestor"
}

variable keyring-id {
  type        = string
  description = "Keyring ID to attach attestor keys"
}

variable crypto-algorithm {
  type        = string
  default     = "RSA_SIGN_PKCS1_4096_SHA512"
  description = "Algorithm used for the async signing keys"
}