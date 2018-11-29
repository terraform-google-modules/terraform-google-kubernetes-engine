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

    describe "default node pool" do
      let(:default_node_pool) { data['nodePools'].select { |p| p['name'] == "default-pool" }.first }

      it "has no initial node count" do
        expect(default_node_pool['initialNodeCount']).to eq nil
      end

      it "does not have autoscaling enabled" do
        expect(default_node_pool['autoscaling']).to eq nil
      end
    end

    describe "node pools" do
      let(:node_pools) { data['nodePools'].reject { |p| p['name'] == "default-pool" } }

      it "has 2" do
        expect(node_pools.count).to eq 2
      end

      describe "pool-01" do
        let(:node_pool) { node_pools.select { |p| p['name'] == "pool-01" }.first }

        it "exists" do
          expect(node_pool).not_to be_nil
        end

        it "is named correctly" do
          expect(node_pool['name']).to eq "pool-01"
        end

        it "is the expected machine type" do
          expect(node_pool['config']['machineType']).to eq 'n1-standard-2'
        end

        it "has autoscaling enabled" do
          expect(node_pool['autoscaling']['enabled']).to eq true
        end

        it "has the expected minimum node count" do
          expect(node_pool['autoscaling']['minNodeCount']).to eq 4
        end

        it "has autorepair enabled" do
          expect(node_pool['management']['autoRepair']).to eq true
        end

        it "has automatic upgrades enabled" do
          expect(node_pool['management']['autoUpgrade']).to eq true
        end

        it "has the expected labels" do
          expect(node_pool['config']['labels']).to eq({
            "all-pools-example" => "true",
            "pool-01-example" => "true",
            "cluster_name" => cluster_name,
            "node_pool" => "pool-01",
          })
        end

        it "has the expected network tags" do
          expect(node_pool['config']['tags']).to match_array([
            "all-node-example",
            "pool-01-example",
            "gke-node-pool-cluster",
            "gke-node-pool-cluster-pool-01",
          ])
        end
      end

      describe "pool-02" do
        let(:node_pool) { node_pools.select { |p| p['name'] == "pool-02" }.first }

        it "exists" do
          expect(node_pool).not_to be_nil
        end

        it "is named correctly" do
          expect(node_pool['name']).to eq "pool-02"
        end

        it "is the expected machine type" do
          expect(node_pool['config']['machineType']).to eq 'n1-standard-2'
        end

        it "has autoscaling enabled" do
          expect(node_pool['autoscaling']['enabled']).to eq true
        end

        it "has the expected minimum node count" do
          expect(node_pool['autoscaling']['minNodeCount']).to eq 2
        end

        it "has the expected maximum node count" do
          expect(node_pool['autoscaling']['maxNodeCount']).to eq 3
        end

        it "has the expected disk size" do
          expect(node_pool['config']['diskSizeGb']).to eq 30
        end

        it "has the expected disk type" do
          expect(node_pool['config']['diskType']).to eq "pd-standard"
        end

        it "has the expected image type" do
          expect(node_pool['config']['imageType']).to eq "COS"
        end

        it "has autorepair disabled" do
          expect(node_pool['management']['autoRepair']).to eq nil
        end

        it "has automatic upgrades disabled" do
          expect(node_pool['management']['autoUpgrade']).to eq nil
        end

        it "has the right service account" do
          expect(node_pool['config']['serviceAccount']).to eq "default"
        end

        it "has the expected labels" do
          expect(node_pool['config']['labels']).to eq({
            "all-pools-example" => "true",
            "cluster_name" => cluster_name,
            "node_pool" => "pool-02",
          })
        end

        it "has the expected network tags" do
          expect(node_pool['config']['tags']).to match_array([
            "all-node-example",
            "gke-node-pool-cluster",
            "gke-node-pool-cluster-pool-02",
          ])
        end
      end
    end
  end
end
