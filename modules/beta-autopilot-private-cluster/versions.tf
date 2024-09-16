/**
 * Copyright 2022 Google LLC
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


terraform {
  required_version = ">=1.3"

  required_providers {
    google = {
      source = "hashicorp/google"
      # Workaround for https://github.com/hashicorp/terraform-provider-google/issues/19428
      version = ">= 5.40.0, != 5.44.0, < 6.2.0, < 7"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      # Workaround for https://github.com/hashicorp/terraform-provider-google/issues/19428
      version = ">= 5.40.0, != 5.44.0, < 6.2.0, < 7"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1"
    }
  }
  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-kubernetes-engine:beta-autopilot-private-cluster/v33.0.3"
  }
}
