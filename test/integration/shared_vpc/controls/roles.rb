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
project_number = attribute('project_number')
host_project_id = attribute('host_project_id')
host_project_number = attribute('host_project_number')
subnetwork = attribute('subnetwork')
region = attribute('region')
cluster_service_account = attribute('service_account')

control "subnet-iam-policy" do
  title "Check if GKE subnet has all needed roles assigned to all expected service-accounts"
  describe command("gcloud compute networks subnets get-iam-policy #{subnetwork} --region #{region} --project=#{host_project_id} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "attached_to_subnet_policy_role" do
      it "it equal compute.networkUser" do
        expect(data['bindings'][0]['role']).to eq 'roles/compute.networkUser'
      end
    end

    describe "policy members" do
      it "it include default service account" do
        expect(data['bindings'][0]['members']).to include "serviceAccount:#{project_number}@cloudservices.gserviceaccount.com"
      end

      it "it include container-engine-robot service account" do
        expect(data['bindings'][0]['members']).to include "serviceAccount:service-#{project_number}@container-engine-robot.iam.gserviceaccount.com"
      end

      it "it include GKE cluster service account" do
        expect(data['bindings'][0]['members']).to include "serviceAccount:#{cluster_service_account}"
      end
    end
  end
end

