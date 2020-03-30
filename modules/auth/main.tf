data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.location
  project  = var.project_id
}

data "google_client_config" "provider" {}

data "template_file" "kubeconfig" {
  template = file("${path.module}/kubeconfig-template.yaml")

  vars = {
    context                = data.google_container_cluster.gke_cluster.name
    cluster_ca_certificate = data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
    endpoint               = data.google_container_cluster.gke_cluster.endpoint
    token                  = data.google_client_config.provider.access_token
  }
}
