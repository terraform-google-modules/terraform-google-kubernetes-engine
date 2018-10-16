data "google_compute_network" "gke_network" {
  name    = "${var.network}"
  project = "${local.network_project_id}"
}

data "google_compute_subnetwork" "gke_subnetwork" {
  name    = "${var.subnetwork}"
  project = "${local.network_project_id}"
  region  = "${var.region}"
}
