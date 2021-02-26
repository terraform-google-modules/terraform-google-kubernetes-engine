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

control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command(
    "gcloud --project=#{attribute("project_id")} container clusters --zone=#{attribute("location")} describe " \
    "#{attribute("cluster_name")} --format=json"
  ) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "cluster" do
      it "is running" do
        expect(data["status"]).to eq "RUNNING"
      end

      it "does not use the private endpoint" do
        expect(data["privateClusterConfig"]["enablePrivateEndpoint"]).to eq false
      end

      it "uses private nodes" do
        expect(data["privateClusterConfig"]["enablePrivateNodes"]).to eq true
      end

      it "has the expected addon settings" do
        expect(data["addonsConfig"]).to include(
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
  end
end
