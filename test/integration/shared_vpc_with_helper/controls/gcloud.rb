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
project_number = attribute('project_number')

location = attribute('location')
cluster_name = attribute('cluster_name')

control "cluster" do
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
    end
  end
end


control "shared_host_services" do
  title "Check if all needed APIs activated for shared VPC host project"
  describe command("gcloud --project=#{project_id} services list  --flatten=\"[].name\" --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        []
      end
    end

    describe "activated_api" do
      it "should contain compute.googleapis.com" do
        expect(data).to include "projects/#{project_number}/services/compute.googleapis.com"
      end

      it "should contain container.googleapis.com" do
        expect(data).to include "projects/#{project_number}/services/container.googleapis.com"
      end

    end
  end
end


#gcloud services list --filter="container.googleapis.com" --project=test-gke-service-project-e2at --flatten="[].name" --format=json