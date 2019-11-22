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
service_account = attribute('service_account')

control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command("gcloud beta --project=#{project_id} container clusters --zone=#{location} describe #{cluster_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "binary auth" do
      it "is enabled" do
        expect(data['binaryAuthorization']['enabled']).to eq true
      end
    end

    describe "network policy" do
      it "is enabled" do
        expect(data['networkPolicy']['enabled']).to eq true
      end
    end

    describe "master authorized networks" do
      it "is enabled" do
        expect(data['masterAuthorizedNetworksConfig']['enabled']).to eq true
      end

      it "has display name set" do
        expect(data['masterAuthorizedNetworksConfig']['cidrBlocks'][0]['displayName']).to eq 'internal subnet'
      end
    end

    describe "horizontal pod autoscaling" do
      it "is enabled" do
        expect(data['addonsConfig']['horizontalPodAutoscaling']['disabled']).to eq true
      end
    end
    
    describe "http load balancing" do
      it "is enabled" do
        expect(data['addonsConfig']['httpLoadBalancing']).to eq({})
      end
    end
    
    describe "private endpoint" do
      it "is enabled" do
        expect(data['privateClusterConfig']['enablePrivateEndpoint']).to eq true
      end
    end

    describe "private nodes" do
      it "is enabled" do
        expect(data['privateClusterConfig']['enablePrivateNodes']).to eq true
      end
    end

    describe 'master ipv4 cidr block' do
      it 'is properly set' do
        expect(data['privateClusterConfig']['masterIpv4CidrBlock']).to eq '172.16.0.16/28'
      end
    end

    describe "node pool labels" do
      it "should have set labels" do
        expect(data['nodeConfig']['labels']).to eq(
          'cluster_name' => 'test-cluster',
          'l1' => 'v1',
          'l2' => 'v2',
          'node_pool' => 'my-node-pool',
          'seven' => 'eight'
        )
      end
    end

    describe "legacy metadata endpoints" do
      it "is disabled" do
        expect(data['nodeConfig']['metadata']['disable-legacy-endpoints']).to eq 'true'
      end
    end

    describe "node pools" do
      it "has two node pools" do
        expect(data['nodePools'].size).to eq 2
      end

      it "are configured properly" do
        expect(data['nodePools']).to include(
          including(
            'name' => 'my-node-pool',
            'autoscaling' => including(
              'enabled' => true,
              'minNodeCount' => 2,
              'maxNodeCount' => 10
            ),
            'config' => including(
              'machineType' => 'n1-standard-1',
              'diskSizeGb' => 50,
              'diskType' => 'pd-ssd',
              'imageType' => 'COS',
              'preemptible' => true,
              'oauthScopes' => including(
                'https://www.googleapis.com/auth/devstorage.read_only',
                'https://www.googleapis.com/auth/monitoring',
                'https://www.googleapis.com/auth/servicecontrol',
                'https://www.googleapis.com/auth/service.management.readonly',
                'https://www.googleapis.com/auth/trace.append',
                'https://www.googleapis.com/auth/logging.write',
              ),
              'labels' => including(
                'l1' => 'v1',
                'l2' => 'v2',
                'seven' => 'eight'
              ),
              'tags' => including(
                'blue',
                'green'
              )
            ),
            'management' => including(
              'autoRepair' => true
            ),
            'initialNodeCount' => 1
          ),
          including(
            'name' => 'my-other-nodepool',
            'autoscaling' => including(
              'enabled' => true,
              'minNodeCount' => 1,
              'maxNodeCount' => 1
            ),
            'config' => including(
              'machineType' => 'n1-standard-2',
              'diskSizeGb' => 50,
              'diskType' => 'pd-ssd',
              'imageType' => 'COS',
              'oauthScopes' => including(
                'https://www.googleapis.com/auth/trace.append',
                'https://www.googleapis.com/auth/service.management.readonly',
                'https://www.googleapis.com/auth/monitoring',
                'https://www.googleapis.com/auth/devstorage.read_only',
                'https://www.googleapis.com/auth/servicecontrol',
                'https://www.googleapis.com/auth/logging.write',
              ),
              'labels' => including(
                'l1' => 'v1',
                'l2' => 'v2',
              ),
              'tags' => including(
                'blue',
                'green',
                'red',
                'white'
              )
            ),
            'management' => including(
              'autoRepair' => true
            ),
            'initialNodeCount' => 1
          )
        )
      end
    end
  end
end
