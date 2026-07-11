/**
 * Copyright 2024 Google LLC
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


moved {
  from = kubernetes_config_map.ip-masq-agent
  to   = kubernetes_config_map.ip_masq_agent
}

moved {
  from = google_project_iam_member.cluster_service_account-nodeService_account
  to   = google_project_iam_member.cluster_service_account_node_service_account
}

moved {
  from = google_project_iam_member.cluster_service_account-metric_writer
  to   = google_project_iam_member.cluster_service_account_metric_writer
}

moved {
  from = google_project_iam_member.cluster_service_account-resourceMetadata-writer
  to   = google_project_iam_member.cluster_service_account_resource_metadata_writer
}

moved {
  from = google_project_iam_member.cluster_service_account-gcr
  to   = google_project_iam_member.cluster_service_account_gcr
}

moved {
  from = google_project_iam_member.cluster_service_account-artifact-registry
  to   = google_project_iam_member.cluster_service_account_artifact_registry
}
