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
location = attribute('location')
cluster_name = attribute('cluster_name')
peering_name = attribute('peering_name')

control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command("gcloud --project=#{project_id} container clusters --zone=#{location} describe #{cluster_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "cluster" do
      it "is running" do
        expect(data['status']).to eq 'RUNNING'
      end

      it "is zonal" do
        expect(data['location']).to match(/^(.*)[1-9]-[a-z]$/)
      end

      it "is single zoned" do
        expect(data['locations'].size).to eq 1
      end

      it "uses the private master endpoint" do
        expect(data['privateClusterConfig']['enablePrivateEndpoint']).to eq true
      end

      it "uses private nodes" do
        expect(data['privateClusterConfig']['enablePrivateNodes']).to eq true
      end

      it "has corresponding peering name" do
        expect(data['privateClusterConfig']['peeringName']).to eq peering_name
      end

      it "has the expected addon settings" do
        expect(data['addonsConfig']).to include(
          "horizontalPodAutoscaling" => {},
          "httpLoadBalancing" => {},
          "kubernetesDashboard" => {
            "disabled" => true,
          },
          "networkPolicyConfig" => {
            "disabled" => true,
          },
        )
      end
    end

    describe "default node pool" do
      let(:default_node_pool) { data['nodePools'].select { |p| p['name'] == "default-pool" }.first }

      it "exists" do
        expect(data['nodePools']).to include(
          including(
            "name" => "default-pool",
          )
        )
      end

      it "is the expected machine type" do
        expect(data['nodePools']).to include(
          including(
            "config" => including(
              "machineType" => "e2-medium",
            ),
          )
        )
      end

      it "has the expected disk size" do
        expect(data['nodePools']).to include(
          including(
            "config" => including(
              "diskSizeGb" => 100,
            ),
          )
        )
      end

    end
  end
end
