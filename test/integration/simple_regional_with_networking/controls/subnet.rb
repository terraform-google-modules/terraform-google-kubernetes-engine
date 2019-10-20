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
network_name = attribute('network_name')
subnet_name = attribute('subnet_name')
region = attribute('region')
ip_range_pods_name = attribute('ip_range_pods_name')
ip_range_services_name = attribute('ip_range_services_name')
control "subnet" do
    title "gcp subnetwork configuration"
    describe command("gcloud compute networks subnets describe #{subnet_name} --project=#{project_id} --region=#{region} --format=json") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }
      let(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
          {}
        end
      end
      it "#should have the correct secondaryIpRanges configuration for #{ip_range_pods_name}" do
        expect(data["secondaryIpRanges"][0]).to include(
          "rangeName"   => ip_range_pods_name,
          "ipCidrRange" => "192.168.0.0/18"
        )
      end
      it "#should have the correct secondaryIpRanges configuration for #{ip_range_services_name}" do
        expect(data["secondaryIpRanges"][1]).to include(
          "rangeName"   => ip_range_services_name,
          "ipCidrRange" => "192.168.64.0/18"
        )
      end
    end
  end
