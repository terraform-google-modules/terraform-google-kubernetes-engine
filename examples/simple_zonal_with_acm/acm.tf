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

module "acm" {
  source           = "../../modules/acm"
  project_id       = var.project_id
  location         = module.gke.location
  cluster_name     = module.gke.name
  sync_repo        = var.acm_sync_repo
  sync_branch      = var.acm_sync_branch
  policy_dir       = var.acm_policy_dir
  cluster_endpoint = module.gke.endpoint
  operator_path    = var.operator_path
}
