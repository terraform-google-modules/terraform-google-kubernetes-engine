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

require 'kubeclient'
require 'rest-client'

require 'base64'

kubernetes_endpoint = attribute('kubernetes_endpoint')
client_token = attribute('client_token')
ca_certificate = attribute('ca_certificate')

control "kubectl" do
  title "Kubernetes configuration"

  describe "kubernetes" do
    let(:kubernetes_http_endpoint) { "https://#{kubernetes_endpoint}/api" }
    let(:client) do
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(Base64.decode64(ca_certificate)))
      Kubeclient::Client.new(
        kubernetes_http_endpoint,
        "v1",
        ssl_options: {
          cert_store: cert_store,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        },
        auth_options: {
          bearer_token: Base64.decode64(client_token),
        },
      )
    end

    describe "nodes" do
      let(:all_nodes) { client.get_nodes }
      let(:taints) { nodes.first.spec.taints.map { |t| t.to_h.select { |k, v| [:effect, :key, :value].include?(k.to_sym) } } }

      describe "pool-01" do
        let(:nodes) do
          all_nodes.select { |n| n.metadata.labels.node_pool == "pool-01" }
        end

        it "has the expected taints" do
          expect(taints).to eq([
            {
              effect: "PreferNoSchedule",
              key: "all-pools-example",
              value: "true",
            },
            {
              effect: "PreferNoSchedule",
              key: "pool-01-example",
              value: "true",
            },
          ])
        end
      end

      describe "pool-02" do
        let(:nodes) do
          all_nodes.select { |n| n.metadata.labels.node_pool == "pool-02" }
        end

        it "has the expected taints" do
          expect(taints).to include(
            {
              effect: "PreferNoSchedule",
              key: "all-pools-example",
              value: "true",
            }
          )
        end
      end
      describe "pool-03" do
        let(:nodes) do
          all_nodes.select { |n| n.metadata.labels.node_pool == "pool-03" }
        end

        it "has the expected taints" do
          expect(taints).to include(
            {
              effect: "PreferNoSchedule",
              key: "all-pools-example",
              value: "true",
            }
          )
        end
      end
    end
  end
end
