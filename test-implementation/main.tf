module "gke" {
  source                        = "../modules/beta-private-cluster"
  project_id                    = "rare-style-447407-s1"
  name                          = "test-custom-role"
  region                        = "us-central1"
  network                       = "default"
  subnetwork                    = "default"
  ip_range_pods                 = "gke-pods"
  ip_range_services             = "gke-services"
  monitoring_metric_writer_role = "projects/rare-style-447407-s1/roles/custom_metrics_writer"
}
