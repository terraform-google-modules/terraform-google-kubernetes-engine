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
region = attribute('region')
location = attribute('location')
cluster_name = attribute('cluster_name')
network = attribute('network')
subnetwork = attribute('subnetwork')
ip_range_pods = attribute('ip_range_pods')
ip_range_services = attribute('ip_range_services')
master_kubernetes_version = attribute('master_kubernetes_version')

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
        expect(data['zone']).to eq location
        expect(data['zone']).not_to eq region
      end

      it "is private" do
        expect(data['privateClusterConfig']['enablePrivateEndpoint']).to eq true
        expect(data['privateClusterConfig']['enablePrivateNodes']).to eq true
      end

      it "has the expected initial cluster version" do
        expect(data['initialClusterVersion']).to eq master_kubernetes_version
      end

      it "is in the expected network" do
        expect(data['network']).to eq network
      end

      it "is in the expected subnetwork" do
        expect(data['subnetwork']).to eq subnetwork
      end

      it "has the expected secondary ip range for pods" do
        expect(data['ipAllocationPolicy']['clusterSecondaryRangeName']).to eq ip_range_pods
      end

      it "has the expected secondary ip range for services" do
        expect(data['ipAllocationPolicy']['servicesSecondaryRangeName']).to eq ip_range_services
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
      let(:node_pool) { data['nodePools'].reject { |p| p['name'] == "default-pool" }.first }

      it "is running the expected version of Kubernetes" do
        expect(node_pool['version']).to eq master_kubernetes_version
      end

      it "has autoscaling enabled" do
        expect(node_pool['autoscaling']['enabled']).to eq true
      end

      it "has the expected minimum node count" do
        expect(node_pool['autoscaling']['minNodeCount']).to eq 1
      end

      it "has the expected maximum node count" do
        expect(node_pool['autoscaling']['maxNodeCount']).to eq 100
      end

      it "is the expected machine type" do
        expect(node_pool['config']['machineType']).to eq 'n1-standard-2'
      end

      it "has the expected disk size" do
        expect(node_pool['config']['diskSizeGb']).to eq 100
      end

      it "has the expected labels" do
        expect(node_pool['config']['labels']).to eq({
          "cluster_name" => cluster_name,
          "node_pool" => "default-node-pool",
        })
      end

      it "has the expected network tags" do
        expect(node_pool['config']['tags']).to eq([
          "gke-#{cluster_name}",
          "gke-#{cluster_name}-default-node-pool",
        ])
      end

      it "has autorepair enabled" do
        expect(node_pool['management']['autoRepair']).to eq true
      end

      it "has autoupgrade disabled" do
        expect(node_pool['management']['autoUpgrade']).to eq nil
      end
    end
  end
end
