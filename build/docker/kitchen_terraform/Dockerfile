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

ARG BUILD_TERRAFORM_IMAGE
ARG BUILD_RUBY_VERSION
# hadolint ignore=DL3006
FROM $BUILD_TERRAFORM_IMAGE as cfkt_terraform



FROM ruby:$BUILD_RUBY_VERSION-alpine

RUN apk add --no-cache \
    bash=4.4.19-r1 \
    curl=7.61.1-r1 \
    git=2.18.1-r0 \
    g++=6.4.0-r9 \
    jq=1.6_rc1-r1 \
    make=4.2.1-r2 \
    musl-dev=1.1.19-r10 \
    python2=2.7.15-r1 \
    python2-dev=2.7.15-r1 \
    py2-pip=10.0.1-r0 \
    ca-certificates=20171114-r3

ADD https://storage.googleapis.com/kubernetes-release/release/v1.12.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

SHELL ["/bin/bash", "-c"]

ENV APP_BASE_DIR="/cftk"

COPY --from=cfkt_terraform $APP_BASE_DIR $APP_BASE_DIR

ARG CREDENTIALS_FILE

ENV HOME="$APP_BASE_DIR/home"
ENV PATH $APP_BASE_DIR/bin:$APP_BASE_DIR/google-cloud-sdk/bin:$PATH
ENV GOOGLE_APPLICATION_CREDENTIALS="$APP_BASE_DIR/workdir/$CREDENTIALS_FILE" \
    CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="$APP_BASE_DIR/workdir/$CREDENTIALS_FILE"

# Fix base64 inconsistency
SHELL ["/bin/bash", "-c"]
RUN echo 'base64() { if [[ $@ == "--decode" ]]; then command base64 -d | more; else command base64 "$@"; fi; }' >> $APP_BASE_DIR/home/.bashrc

RUN terraform --version && \
    gcloud --version && \
    ruby --version && \
    bundle --version

COPY ./Gemfile /opt/kitchen/

WORKDIR /opt/kitchen
RUN bundle install

RUN gcloud components install beta --quiet

WORKDIR $APP_BASE_DIR/workdir
