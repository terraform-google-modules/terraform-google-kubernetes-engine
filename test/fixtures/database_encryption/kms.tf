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

resource "google_kms_key_ring" "db_key_ring" {
  name     = "db-key-ring"
  project  = "${var.project_id}"
  location = "${var.region}"
}

resource "google_kms_crypto_key" "db_key" {
  name            = "db-key"
  key_ring        = "${google_kms_key_ring.db_key_ring.self_link}"

  version_template {
    algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION"
  }
}

data "google_project" "project_data" {
  project_id = "${var.project_id}"
}

resource "google_kms_crypto_key_iam_member" "kms_permissions" {
  crypto_key_id = "${google_kms_crypto_key.db_key.id}"
  member        = "serviceAccount:service-${data.google_project.project_data.number}@container-engine-robot.iam.gserviceaccount.com"
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}