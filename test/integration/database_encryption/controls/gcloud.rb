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
region  = attribute('region')

control "gcloud" do
  title "GKE "
  describe command("gcloud beta --project=#{project_id} container clusters --zone #{location} describe #{cluster_name} --format 'json(databaseEncryption)'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)["databaseEncryption"]
      else
        {}
      end
    end

    describe "database-encryption" do
      it "is ENCRYPTED" do
        expect(data['state']).to eq "ENCRYPTED"
      end

      it "has valid key" do
        expect(data['keyName']).to eq "projects/#{project_id}/locations/#{region}/keyRings/db-key-ring/cryptoKeys/db-key"
      end
    end
  end
end
