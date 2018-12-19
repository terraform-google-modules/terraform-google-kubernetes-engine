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
  cluster_type = "deploy-service"
}

provider "google" {
  credentials = "${file(local.credentials_path)}"
  region      = "${local.region}"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
}

data "google_client_config" "default" {}

module "gke" {
  source            = "../../"
  project_id        = "${local.project_id}"
  name              = "${local.cluster_type}-cluster"
  region            = "${local.region}"
  network           = "${local.network}"
  subnetwork        = "${local.subnetwork}"
  ip_range_pods     = "${local.ip_range_pods}"
  ip_range_services = "${local.ip_range_services}"
  kubernetes_version = "1.9.7-gke.11"
}

resource "kubernetes_pod" "nginx-example" {
  metadata {
    name = "nginx-example"

    labels {
      maintained_by = "terraform"
      app           = "nginx-example"
    }
  }

  spec {
    container {
      image = "nginx:1.7.9"
      name  = "nginx-example"
    }
  }

  depends_on = ["module.gke"]
}

resource "kubernetes_service" "nginx-example" {
  metadata {
    name = "terraform-example"
  }

  spec {
    selector {
      app = "${kubernetes_pod.nginx-example.metadata.0.labels.app}"
    }

    session_affinity = "ClientIP"

    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }

  depends_on = ["module.gke"]
}
