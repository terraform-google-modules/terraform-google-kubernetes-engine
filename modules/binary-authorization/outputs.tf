output key {
  value       = google_kms_crypto_key.crypto-key.name
  description = "Name of the Key created for the attestor"
}

output attestor {
  value       = google_binary_authorization_attestor.attestor.name
  description = "Name of the built attestor"
}