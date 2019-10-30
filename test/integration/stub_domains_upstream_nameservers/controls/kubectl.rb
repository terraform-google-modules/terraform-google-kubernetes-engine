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

    describe "configmap" do
      describe "kube-dns" do
        let(:kubedns_configmap) { client.get_config_map("kube-dns", "kube-system") }

        it "is created by Terraform" do
          expect(kubedns_configmap.metadata.labels.maintained_by).to eq "terraform"
        end

        it "reflects the stub_domains configuration" do
          expect(JSON.parse(kubedns_configmap.data.stubDomains)).to eq({
            "example.com" => [
              "10.254.154.11",
              "10.254.154.12",
            ],
            "example.net" => [
              "10.254.154.11",
              "10.254.154.12",
            ],
          })
        end

        it "reflects the upstream_nameservers configuration" do
          expect(JSON.parse(kubedns_configmap.data.upstreamNameservers)).to eq(["8.8.8.8", "8.8.4.4"])
        end
      end

      describe "ipmasq" do
        let(:ipmasq_configmap) { client.get_config_map("ip-masq-agent", "kube-system") }

        it "is created by Terraform" do
          expect(ipmasq_configmap.metadata.labels.maintained_by).to eq "terraform"
        end

        it "is configured properly" do
          expect(YAML.load(ipmasq_configmap.data.config)).to eq({
            "nonMasqueradeCIDRs" => [
              "10.0.0.0/8",
              "172.16.0.0/12",
              "192.168.0.0/16",
            ],
            "resyncInterval" => "60s",
            "masqLinkLocal" => false,
          })
        end
      end
    end
  end
end
