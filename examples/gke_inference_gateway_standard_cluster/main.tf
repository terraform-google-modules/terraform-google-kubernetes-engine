/**
 * Copyright 2025 Google LLC
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
  cluster_type          = "gke-standard"
  default_workload_pool = "${var.project_id}.svc.id.goog"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  project = var.project_id
  region  = var.region
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/gke-standard-cluster"
  version = "~> 39.0"

  project_id    = var.project_id
  name       = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  location   = var.region
  network    = var.network
  subnetwork = var.subnetwork
  release_channel = "RAPID"
  gateway_api_config = {
    channel = "CHANNEL_STANDARD"
  }
  monitoring_config = {
    enable_managed_prometheus = true
    enabled_components        = ["SYSTEM_COMPONENTS", "DCGM"]
  }
  logging_service    = "logging.googleapis.com/kubernetes"


  ip_allocation_policy = {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  deletion_protection      = false
  remove_default_node_pool = false

  workload_identity_config = {
    workload_pool = local.default_workload_pool
  }

  addons_config = {
    http_load_balancing = {
      enabled = true
    }
    dns_cache_config = {
      enabled = var.dns_cache
    }

    gce_persistent_disk_csi_driver_config = {
      enabled = var.gce_pd_csi_driver
    }
  }
  enable_shielded_nodes = true
}

module "node_pool" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/gke-node-pool"
  version = "~> 39.0"

  project_id  = var.project_id
  location = var.zone
  cluster  = module.gke.cluster_name
  name     = "gpupool"
  node_count = 1

  node_config = {
    disk_size_gb    = 200
    disk_type       = "pd-standard"
    image_type      = "COS_CONTAINERD"
    machine_type    = "a3-highgpu-2g"
    service_account = var.service_account
    guest_accelerator = {
      type  = "nvidia-h100-80gb"
      count = 2
    }
    gpu_driver_installation_config = {
      gpu_driver_version = "LATEST"
    }
    workload_metadata_config = {
      mode = "GKE_METADATA"
    }
  }
}

resource "kubernetes_secret" "hf_secret" {
  metadata {
    name = "hf-token"
  }
  data = {
    token = var.hf_token
  }
  type = "Opaque"
}

resource "kubernetes_config_map" "vllm_adapters" {
  metadata {
    name = "vllm-llama3.1-8b-adapters"
  }
  data = {
    "configmap.yaml" = <<-EOT
      vLLMLoRAConfig:
        name: vllm-llama3.1-8b-instruct
        port: 8000
        defaultBaseModel: meta-llama/Llama-3.1-8B-Instruct
        ensureExist:
          models:
          - id: food-review
            source: Kawon/llama3.1-food-finetune_v14_r8
          - id: cad-fabricator
            source: redcathode/fabricator
    EOT
  }
}

resource "kubernetes_deployment" "vllm" {
  metadata {
    name = "vllm-llama3.1-8b-instruct"
  }
  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "vllm-llama3.1-8b-instruct"
      }
    }
    template {
      metadata {
        labels = {
          app = "vllm-llama3.1-8b-instruct"
        }
      }
      spec {
        termination_grace_period_seconds = 130
        enable_service_links             = false
        container {
          name              = "vllm"
          image             = "vllm/vllm-openai:latest"
          image_pull_policy = "Always"
          command           = ["python3", "-m", "vllm.entrypoints.openai.api_server"]
          args = [
            "--model", "meta-llama/Llama-3.1-8B-Instruct",
            "--tensor-parallel-size", "1",
            "--port", "8000",
            "--enable-lora",
            "--max-loras", "2",
            "--max-cpu-loras", "12"
          ]
          port {
            container_port = 8000
            name           = "http"
            protocol       = "TCP"
          }
          env {
            name  = "VLLM_USE_V1"
            value = "1"
          }
          env {
            name  = "PORT"
            value = "8000"
          }
          env {
            name = "HUGGING_FACE_HUB_TOKEN"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.hf_secret.metadata[0].name
                key  = "token"
              }
            }
          }
          env {
            name  = "VLLM_ALLOW_RUNTIME_LORA_UPDATING"
            value = "true"
          }
          lifecycle {
            pre_stop {
              exec {
                command = ["/bin/sh", "-c", "sleep 30"]
              }
            }
          }
          resources {
            limits = {
              "nvidia.com/gpu" = 1
            }
            requests = {
              "nvidia.com/gpu" = 1
            }
          }
          liveness_probe {
            http_get {
              path   = "/health"
              port   = "http"
              scheme = "HTTP"
            }
            period_seconds     = 1
            success_threshold  = 1
            failure_threshold  = 5
            timeout_seconds    = 1
          }
          readiness_probe {
            http_get {
              path   = "/health"
              port   = "http"
              scheme = "HTTP"
            }
            period_seconds     = 1
            success_threshold  = 1
            failure_threshold  = 1
            timeout_seconds    = 1
          }
          startup_probe {
            http_get {
              path   = "/health"
              port   = "http"
              scheme = "HTTP"
            }
            failure_threshold   = 600
            initial_delay_seconds = 2
            period_seconds      = 1
          }
          volume_mount {
            mount_path = "/data"
            name       = "data"
          }
          volume_mount {
            mount_path = "/dev/shm"
            name       = "shm"
          }
          volume_mount {
            mount_path = "/adapters"
            name       = "adapters"
          }
        }
        container {
          name  = "lora-adapter-syncer"
          image = "us-central1-docker.pkg.dev/k8s-staging-images/gateway-api-inference-extension/lora-syncer:main"
          image_pull_policy = "Always"
          env {
            name  = "DYNAMIC_LORA_ROLLOUT_CONFIG"
            value = "/config/configmap.yaml"
          }
          volume_mount {
            name       = "config-volume"
            mount_path = "/config"
          }
        }
        volume {
          name = "data"
          empty_dir {}
        }
        volume {
          name = "shm"
          empty_dir {
            medium = "Memory"
          }
        }
        volume {
          name = "adapters"
          empty_dir {}
        }
        volume {
          name = "config-volume"
          config_map {
            name = kubernetes_config_map.vllm_adapters.metadata[0].name
          }
        }
        node_selector = {
          "cloud.google.com/gke-accelerator" = "nvidia-h100-80gb"
        }
      }
    }
  }
}

resource "null_resource" "apply_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api-inference-extension/releases/download/v1.0.0/manifests.yaml"
  }
  depends_on = [module.gke]
}

resource "kubernetes_cluster_role" "metrics_reader" {
  metadata {
    name = "inference-gateway-metrics-reader"
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_service_account" "metrics_reader" {
  metadata {
    name      = "inference-gateway-sa-metrics-reader"
    namespace = "default"
  }
}

resource "kubernetes_cluster_role_binding" "metrics_reader" {
  metadata {
    name = "inference-gateway-sa-metrics-reader-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.metrics_reader.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.metrics_reader.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_secret" "metrics_reader_token" {
  metadata {
    name      = "inference-gateway-sa-metrics-reader-secret"
    namespace = "default"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.metrics_reader.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role" "secret_reader" {
  metadata {
    name = "inference-gateway-sa-metrics-reader-secret-read"
  }
  rule {
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = [kubernetes_secret.metrics_reader_token.metadata[0].name]
    verbs          = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "gmp_secret_reader" {
  metadata {
    name = "gmp-system:collector:inference-gateway-sa-metrics-reader-secret-read"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.secret_reader.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = "collector"
    namespace = "gmp-system"
  }
}

resource "helm_release" "inference_pool" {
  name       = "vllm-llama3.1-8b-instruct"
  repository = "oci://registry.k8s.io/gateway-api-inference-extension/charts"
  chart      = "inferencepool"
  version    = "v1.0.0"

  set {
    name  = "inferencePool.modelServers.matchLabels.app"
    value = "vllm-llama3.1-8b-instruct"
  }
  set {
    name  = "provider.name"
    value = "gke"
  }
  set {
    name  = "healthCheckPolicy.create"
    value = "false"
  }
  depends_on = [kubernetes_deployment.vllm, null_resource.apply_crds]
}

resource "kubernetes_manifest" "food_review_model" {
  manifest = {
    "apiVersion" = "inference.networking.k8s.io/v1alpha1"
    "kind"       = "InferenceObjective"
    "metadata" = {
      "name" = "food-review"
    }
    "spec" = {
      "priority" = 10
      "poolRef" = {
        "name" = "vllm-llama3.1-8b-instruct"
        "kind" = "InferencePool"
      }
    }
  }
  depends_on = [helm_release.inference_pool]
}

resource "kubernetes_manifest" "base_model" {
  manifest = {
    "apiVersion" = "inference.networking.k8s.io/v1alpha1"
    "kind"       = "InferenceObjective"
    "metadata" = {
      "name" = "llama3-base-model"
    }
    "spec" = {
      "priority" = 20
      "poolRef" = {
        "name" = "vllm-llama3.1-8b-instruct"
        "kind" = "InferencePool"
      }
    }
  }
  depends_on = [helm_release.inference_pool]
}

resource "kubernetes_manifest" "health_check_policy" {
  manifest = {
    "apiVersion" = "networking.gke.io/v1"
    "kind"       = "HealthCheckPolicy"
    "metadata" = {
      "name"      = "health-check-policy"
      "namespace" = "default"
    }
    "spec" = {
      "targetRef" = {
        "group" = "inference.networking.k8s.io"
        "kind"  = "InferencePool"
        "name"  = "vllm-llama3.1-8b-instruct"
      }
      "default" = {
        "config" = {
          "type" = "HTTP"
          "httpHealthCheck" = {
            "requestPath" = "/health"
            "port"        = 8000
          }
        }
      }
    }
  }
  depends_on = [helm_release.inference_pool]
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind"       = "Gateway"
    "metadata" = {
      "name" = "inference-gateway"
    }
    "spec" = {
      "gatewayClassName" = "gke-l7-regional-external-managed"
      "listeners" = [
        {
          "protocol" = "HTTP"
          "port"     = 80
          "name"     = "http"
        }
      ]
    }
  }
  depends_on = [helm_release.inference_pool]
}

resource "kubernetes_manifest" "http_route" {
  manifest = {
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind"       = "HTTPRoute"
    "metadata" = {
      "name" = "my-route"
    }
    "spec" = {
      "parentRefs" = [
        {
          "name" = "inference-gateway"
        }
      ]
      "rules" = [
        {
          "matches" = [
            {
              "path" = {
                "type"  = "PathPrefix"
                "value" = "/"
              }
            }
          ]
          "backendRefs" = [
            {
              "name"  = "vllm-llama3.1-8b-instruct"
              "group" = "inference.networking.k8s.io"
              "kind"  = "InferencePool"
            }
          ]
        }
      ]
    }
  }
  depends_on = [kubernetes_manifest.gateway]
}