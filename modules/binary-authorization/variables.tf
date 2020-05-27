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

variable "project_id" {
  type        = string
  description = "Project ID to apply services into"
}

variable "attestor-name" {
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
