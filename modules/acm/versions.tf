
/**
 * Copyright 2021 Google LLC
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
  required_version = ">= 0.13.0"

  provider_meta "google" {
    module_name = "blueprints/terraform/terraform-google-kubernetes-engine:acm/v32.0.2"
  }

  provider_meta "google-beta" {
    module_name = "blueprints/terraform/terraform-google-kubernetes-engine:acm/v32.0.2"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.32.0, < 6"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.32.0, < 6"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.3"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7"
    }
  }
}
