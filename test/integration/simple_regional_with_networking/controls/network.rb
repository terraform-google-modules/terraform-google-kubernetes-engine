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

project_id = attribute('project_id')
network_name = attribute('network_name')
subnet_name = attribute('subnet_name')
control "network" do
    title "gcp network configuration"
    describe google_compute_network(
      project: project_id,
      name: network_name
    ) do
      it { should exist }
      its ('subnetworks.count') { should eq 1 }
      its ('subnetworks.first') { should match subnet_name }
    end
  end
