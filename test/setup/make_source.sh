#!/usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "#!/usr/bin/env bash" > ../source.sh

folder_id=$(terraform output folder_id)
echo "export TF_VAR_folder_id='$folder_id'" >> ../source.sh

project_ids=$(terraform output project_ids)
echo "export TF_VAR_project_ids='$project_ids'" >> ../source.sh

registry_project_id=$(terraform output registry_project_id)
echo "export TF_VAR_registry_project_id='$registry_project_id'" >> ../source.sh

sa_json=$(terraform output sa_key)
# shellcheck disable=SC2086
echo "export SERVICE_ACCOUNT_JSON='$(echo $sa_json | base64 --decode)'" >> ../source.sh

compute_engine_service_accounts=$(terraform output compute_engine_service_accounts)
echo "export TF_VAR_compute_engine_service_accounts='$compute_engine_service_accounts'" >> ../source.sh

billing_account=$(terraform output billing_account)
echo "export TF_VAR_billing_account='$billing_account'" >> ../source.sh

svpc_service_project_id=$(terraform output svpc_service_project_id)
echo "export TF_VAR_svpc_service_project_id='$svpc_service_project_id'" >> ../source.sh

svpc_host_project_id=$(terraform output svpc_host_project_id)
echo "export TF_VAR_svpc_host_project_id='$svpc_host_project_id'" >> ../source.sh
