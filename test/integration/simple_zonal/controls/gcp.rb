# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

control "gcp" do
  title "Native InSpec Resources"

  service_account = attribute("service_account")
  project_id = attribute("project_id")

  if service_account.start_with? "projects/"
    service_account_name = service_account
  else
    service_account_name = "projects/#{project_id}/serviceAccounts/#{service_account}"
  end

  describe google_service_account(name: service_account_name) do
    its("display_name") { should eq "Terraform-managed service account for cluster #{attribute("cluster_name")}" }
    its("project_id") { should eq project_id }
  end
end
