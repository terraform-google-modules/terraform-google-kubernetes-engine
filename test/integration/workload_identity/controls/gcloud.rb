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
wi_gsa_to_k8s_sa = {
  attribute('default_wi_email') => attribute('default_wi_ksa_name'),
  attribute('existing_ksa_email') => attribute('existing_ksa_name'),
  attribute('existing_gsa_email') => attribute('existing_gsa_name')
}

control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command("gcloud beta --project=#{project_id} container clusters --zone=#{location} describe #{cluster_name} --format=json --format=\"json(nodePools[0].config.workloadMetadataConfig.nodeMetadata)\"") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "workload metada config" do
      it "is secure" do
        expect(data['nodePools'][0]["config"]["workloadMetadataConfig"]["nodeMetadata"]).to eq 'GKE_METADATA_SERVER'
      end
    end
  end

  describe command("gcloud beta --project=#{project_id} container clusters --zone=#{location} describe #{cluster_name} --format=json --format=\"json(workloadIdentityConfig)\"") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "workload identity config" do
      it "is has correct namespace" do
        expect(data["workloadIdentityConfig"]["identityNamespace"]).to eq "#{project_id}.svc.id.goog"
      end
    end
  end
  wi_gsa_to_k8s_sa.each do |gsa_email,ksa_name|
    describe command("gcloud iam service-accounts get-iam-policy #{gsa_email} --format=json") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }

      let!(:iam) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
          {}
        end
      end
      it "has expected workload identity user roles" do
        expect(iam['bindings'][0]).to include("members" => ["serviceAccount:#{project_id}.svc.id.goog[default/#{ksa_name}]"], "role" => "roles/iam.workloadIdentityUser")
      end
    end
  end
end
