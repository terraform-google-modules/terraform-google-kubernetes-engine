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

      it "is regional" do
        expect(data['location']).to match(/^.*[1-9]$/)
      end

      it "uses public nodes and master endpoint" do
        expect(data['privateClusterConfig']).to eq nil
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

      it "has the expected databaseEncryption config" do
        expect(data['databaseEncryption']).to eq({
          "state" => 'DECRYPTED',
        })
      end

      it "has the expected shieldedNodes config" do
        expect(data['shieldedNodes']).to eq({
          "enabled" => true,
        })
      end

      it "has the expected binaryAuthorization config" do
        expect(data['binaryAuthorization']).to eq({
          "enabled" => true,
        })
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
    end

    describe "node pool" do
      let(:node_pools) { data['nodePools'].reject { |p| p['name'] == "default-pool" } }

      it "has autoscaling enabled" do
        expect(node_pools).to include(
          including(
            "autoscaling" => including(
              "enabled" => true,
            ),
          )
        )
      end

      it "has the expected minimum node count" do
        expect(node_pools).to include(
          including(
            "autoscaling" => including(
              "minNodeCount" => 1,
            ),
          )
        )
      end

      it "has the expected maximum node count" do
        expect(node_pools).to include(
          including(
            "autoscaling" => including(
              "maxNodeCount" => 100,
            ),
          )
        )
      end

      it "is the expected machine type" do
        expect(node_pools).to include(
          including(
            "config" => including(
              "machineType" => "e2-medium",
            ),
          )
        )
      end

      it "has the expected disk size" do
        expect(node_pools).to include(
          including(
            "config" => including(
              "diskSizeGb" => 100,
            ),
          )
        )
      end

      it "has the expected labels" do
        expect(node_pools).to include(
          including(
            "config" => including(
              "labels" => including(
                "cluster_name" => cluster_name,
                "node_pool" => "default-node-pool",
              ),
            ),
          )
        )
      end

      it "has the expected network tags" do
        expect(node_pools).to include(
          including(
            "config" => including(
              "tags" => match_array([
                "gke-#{cluster_name}",
                "gke-#{cluster_name}-default-node-pool",
              ]),
            ),
          )
        )
      end

      it "has autorepair enabled" do
        expect(node_pools).to include(
          including(
            "management" => including(
              "autoRepair" => true,
            ),
          )
        )
      end

      it "has autoupgrade enabled" do
        expect(node_pools).to include(
          including(
            "management" => including(
              "autoUpgrade" => true,
            ),
          )
        )
      end
    end
  end
end
