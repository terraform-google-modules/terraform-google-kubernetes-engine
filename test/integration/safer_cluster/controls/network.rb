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

project_id   = attribute('project_id')
cluster_name = attribute('cluster_name')

control "network" do
  title "gcp network configuration"
  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include "gke-#{cluster_name[0,25]}-intra-cluster-egress" }
    its('firewall_names') { should include "gke-#{cluster_name[0,25]}-webhooks" }
  end

end
