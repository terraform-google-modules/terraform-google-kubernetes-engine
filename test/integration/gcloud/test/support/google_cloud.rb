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

require 'googleauth'
require 'google/apis/compute_v1'

def google_compute_service
  Google::Apis::ComputeV1::ComputeService.new.tap do |service|
    service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/cloud-platform'])
  end
end
