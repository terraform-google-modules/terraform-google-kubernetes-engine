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
network = attribute('network')
subnetwork = attribute('subnetwork')
ip_range_pods = attribute('ip_range_pods')
ip_range_services = attribute('ip_range_services')

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
          "networkPolicyConfig" => {},
        })
      end
    end
  end
end
