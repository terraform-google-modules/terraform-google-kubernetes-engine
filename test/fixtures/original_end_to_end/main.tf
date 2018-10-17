provider "google" {
  credentials              = "${file(var.credentials_path)}"
  region                   = "${var.region}"
}

provider "google-beta" {
  credentials              = "${file(var.credentials_path)}"
  region                   = "${var.region}"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
}
data "google_client_config" "default" {}
module "gke" {
  source               = "../../../"
  project_id           = "${var.project_id}"
  name                 = "regional-end-to-end-cluster"
  regional             = true
  region               = "${var.region}"
  kubernetes_version   = "${var.kubernetes_version}"
  network              = "${var.network}"
  subnetwork           = "${var.subnetwork}"
  ip_range_pods        = "${var.ip_range_pods}"
  ip_range_services    = "${var.ip_range_services}"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true
  stub_domains {
    "example.com" = [
      "10.254.154.11",
      "10.254.154.12",
    ]
    "testola.com" = [
      "10.254.154.11",
      "10.254.154.12",
    ]
  }
  non_masquerade_cidrs = [
    "10.0.0.0/8",
    "192.168.20.0/24",
    "192.168.21.0/24",
  ]
  node_pools = [
    {
      name                = "pool-01"
      machine_type        = "n1-standard-1"
      image_type          = "COS"
      initial_node_count = 2
      min_count          = 1
      max_count          = 2
      auto_upgrade       = false
      disk_size_gb       = 30
      disk_type          = "pd-standard"
      service_account    = "${var.node_pool_service_account}"
    },
  ]
  node_pools_labels = {
    all = {
      all_pools_label = "something"
    }
    pool-01 = {
      pool_01_label         = "yes"
      pool_01_another_label = "no"
    }
  }
  node_pools_taints = {
    all = [
      {
        key    = "all_pools_taint"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
    pool-01 = [
      {
        key    = "pool_01_taint"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
      {
        key    = "pool_01_another_taint"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }
  node_pools_tags = {
    all = [
      "all-node-network-tag",
    ]
    pool-01 = [
      "pool-01-network-tag",
    ]
  }
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
