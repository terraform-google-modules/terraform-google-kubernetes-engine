/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  required_enabled_apis = [
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}

module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 10.0"

  project_id    = var.project_id
  activate_apis = local.required_enabled_apis

  disable_services_on_destroy = var.disable_services_on_destroy
  disable_dependent_services  = var.disable_dependent_services
}

resource "google_binary_authorization_attestor" "attestor" {
  project = var.project_id
  name    = "${var.attestor-name}-attestor"
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
  project = var.project_id
  name    = "${var.attestor-name}-attestor-note"
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
