# Copyright 2018 Google LLC
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

ARG BASE_IMAGE

# hadolint ignore=DL3006
FROM $BASE_IMAGE

RUN apk add --no-cache \
    ca-certificates=20190108-r0

ADD https://storage.googleapis.com/kubernetes-release/release/v1.12.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

WORKDIR /opt/kitchen
COPY Gemfile .
RUN bundle install
WORKDIR $APP_BASE_DIR/workdir
