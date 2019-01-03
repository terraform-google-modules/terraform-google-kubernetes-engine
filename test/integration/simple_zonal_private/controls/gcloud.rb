# Copyright 2018 Google LLC
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

project_id = attribute('project_id')
location = attribute('location')
cluster_name = attribute('cluster_name')

credentials_path = attribute('credentials_path')
ENV['CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE'] = credentials_path

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

      it "is private" do
        expect(data['privateClusterConfig']['enablePrivateEndpoint']).to eq true
        expect(data['privateClusterConfig']['enablePrivateNodes']).to eq true
      end

      it "has the expected initial cluster version" do
        expect(data['initialClusterVersion']).to eq "1.11.4-gke.13"
      end

      it "has the expected addon settings" do
        expect(data['addonsConfig']).to eq({
          "horizontalPodAutoscaling" => {
            "disabled" => true,
          },
          "httpLoadBalancing" => {},
          "kubernetesDashboard" => {
            "disabled" => true,
          },
          "networkPolicyConfig" => {
            "disabled" => true,
          },
        })
      end
    end

    describe "default node pool" do
      let(:default_node_pool) { data['nodePools'].select { |p| p['name'] == "default-pool" }.first }

      it "has no initial node count" do
        expect(default_node_pool['initialNodeCount']).to eq nil
      end

      it "does not have autoscaling enabled" do
        expect(default_node_pool['autoscaling']).to eq nil
      end
    end

    describe "node pool" do
      let(:node_pools) { data['nodePools'].reject { |p| p['name'] == "default-pool" } }

      it "is running the expected version of Kubernetes" do
        expect(node_pools).to include(
          including(
            "version" => "1.11.4-gke.13",
          )
        )
      end

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
              "machineType" => "n1-standard-2",
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
    end
  end
end
