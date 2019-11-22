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
bastion_name = attribute('bastion_name')
bastion_zone = attribute('bastion_zone')
service_account = attribute('service_account')

control "gcloud" do
  title "Bastion Host configuration"
  describe command("gcloud --project=#{project_id} compute instances describe #{bastion_name} --zone=#{bastion_zone} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe 'machineType' do
      it 'is g1-small' do
        expect(data['machineType']).to include 'g1-small'
      end
    end

  end
  
  describe command("gcloud --project=#{project_id} compute disks describe #{bastion_name} --zone=#{bastion_zone} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end  
  
    describe 'os' do
      it 'is Debian 9' do
        expect(data['sourceImage']).to include 'debian-cloud/global/images/debian-9'
      end
    end
  end
end
