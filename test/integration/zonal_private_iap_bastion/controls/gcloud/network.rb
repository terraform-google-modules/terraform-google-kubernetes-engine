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
region = attribute('region')
network_name = attribute('network_name')
subnet_name = attribute('subnet_name')
router_name = attribute('router_name')
cluster_name = attribute('cluster_name')

control "gcloud" do
  title "Network configuration"
  describe command("gcloud --project=#{project_id} compute networks describe #{network_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe 'subnet list' do
      it 'has 1 subnet' do
        expect(data['subnetworks'].size).to eq 1
      end

      it 'has subnet named ' + subnet_name do
        expect(data['subnetworks'][0]).to include subnet_name
      end
    end 

  end
  describe command("gcloud --project=#{project_id} compute networks subnets describe #{subnet_name} --region #{region} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe 'subnet configuration' do
      it 'should have specified CIDR range' do
        expect(data['ipCidrRange']).to eq '10.0.0.0/24'
      end
      
      it 'should have private access enabled' do
        expect(data['privateIpGoogleAccess']).to eq true
      end

      it 'should have expected secondary ranges' do
        expect(data['secondaryIpRanges'].size).to eq 2
        expect(data['secondaryIpRanges']).to include(
          including(
            'rangeName' => 'my-network-' + cluster_name + '-pod-range',
            'ipCidrRange' => '10.1.0.0/16'
          ),
          including(
            'rangeName' => 'my-network-' + cluster_name + '-service-range',
            'ipCidrRange' => '10.2.0.0/20'
          )
        )
      end
    end

  end

  describe command("gcloud --project=#{project_id} compute routers describe #{router_name} --region #{region} --format=json") do
    its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }

      let!(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
          {}
      end
    end

    describe 'router configuration' do
      it 'should be in the ' + network_name + ' network' do
        expect(data['network']).to include network_name
      end
      it 'should have a nat' do
        expect(data['nats'].size).to eq 1
      end
    end
  end

end
