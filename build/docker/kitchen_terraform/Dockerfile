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
        bash=4.3.42-r5 \
        curl=7.60.0-r1 \
        git=2.8.6-r0 \
        g++=5.3.0-r0 \
        jq=1.5-r2 \
        make=4.1-r1 \
        musl-dev=1.1.14-r16 \
        python=2.7.14-r0 \
        python-dev=2.7.14-r0 \
        py-pip=8.1.2-r0

SHELL ["/bin/bash", "-c"]

ENV APP_BASE_DIR="/cftk"

COPY --from=cfkt_terraform $APP_BASE_DIR $APP_BASE_DIR

ENV HOME="$APP_BASE_DIR/home"
ENV PATH $APP_BASE_DIR/bin:$APP_BASE_DIR/google-cloud-sdk/bin:$PATH
ENV GOOGLE_APPLICATION_CREDENTIALS="$CREDENTIALS_PATH" \
    CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="$CREDENTIALS_PATH"

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
