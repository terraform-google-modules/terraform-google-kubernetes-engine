resource "google_binary_authorization_attestor" "attestor" {
  name = "${var.attestor-name}-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.build-note.name
    public_keys {
      id = data.google_kms_crypto_key_version.version.id
      pkix_public_key {
        public_key_pem      = data.google_kms_crypto_key_version.version.public_key[0].pem
        signature_algorithm = data.google_kms_crypto_key_version.version.public_key[0].algorithm
      }
    }
  }
}

resource "google_container_analysis_note" "build-note" {
  name = "${var.attestor-name}-attestor-note"
  attestation_authority {
    hint {
      human_readable_name = "${var.attestor-name} Attestor"
    }
  }
}

# KEYS

data "google_kms_crypto_key_version" "version" {
  crypto_key = google_kms_crypto_key.crypto-key.id
}

resource "google_kms_crypto_key" "crypto-key" {
  name     = "${var.attestor-name}-attestor-key"
  key_ring = var.keyring-id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = var.crypto-algorithm
  }

  lifecycle {
    prevent_destroy = false
  }
}
