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
location = attribute('location')
cluster_name = attribute('cluster_name')
k8s_service_account_email = attribute('k8s_service_account_email')
k8s_service_account_name = attribute('k8s_service_account_name')

control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command("gcloud beta --project=#{project_id} container clusters --region=#{location} describe #{cluster_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "mesh id" do
      it "is correct" do
        expect(data['resourceLabels']["mesh_id"]).to eq "proj-#{project_number}"
      end
    end
  end

  describe command("gcloud container hub memberships describe gke-asm-membership --project=#{project_id} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:hub) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end
    it "membership has expected gke cluster" do
      expect(hub['endpoint']["gkeCluster"]["resourceLink"]).to eq "//container.googleapis.com/projects/#{project_id}/locations/#{location}/clusters/#{cluster_name}"
    end
  end
end
