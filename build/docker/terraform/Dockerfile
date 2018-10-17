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

FROM alpine:3.8 as builder

RUN apk add --no-cache \
        bash=4.4.19-r1 \
        git=2.18.0-r0 \
        go=1.10.1-r0 \
        make=4.2.1-r2 \
        musl-dev=1.1.19-r10

ENV APP_BASE_DIR="/cftk"

RUN mkdir -p $APP_BASE_DIR/home && \
    mkdir -p $APP_BASE_DIR/bin && \
    mkdir -p $APP_BASE_DIR/workdir

ENV GOPATH="/root/go"

ARG BUILD_PROVIDER_GOOGLE_VERSION
ENV PROVIDER_GOOGLE_VERSION="${BUILD_PROVIDER_GOOGLE_VERSION}"

RUN mkdir -p $APP_BASE_DIR/home/.terraform.d/plugins && \
    mkdir -p $GOPATH/src/github.com/terraform-providers && \
    git clone https://github.com/terraform-providers/terraform-provider-google.git $GOPATH/src/github.com/terraform-providers/terraform-provider-google

WORKDIR $GOPATH/src/github.com/terraform-providers/terraform-provider-google
RUN git fetch --all --tags --prune && \
    git checkout tags/v${PROVIDER_GOOGLE_VERSION} -b v${PROVIDER_GOOGLE_VERSION} && \
    make build && \
    mv $GOPATH/bin/terraform-provider-google $APP_BASE_DIR/home/.terraform.d/plugins



FROM alpine:3.8

RUN apk add --no-cache \
        bash=4.4.19-r1 \
        curl=7.61.1-r0 \
        git=2.18.0-r0 \
        jq=1.6_rc1-r1 \
        make=4.2.1-r2 \
        python2=2.7.15-r1

ENV APP_BASE_DIR="/cftk"

COPY --from=builder $APP_BASE_DIR $APP_BASE_DIR

ENV HOME="$APP_BASE_DIR/home"
ENV PATH $APP_BASE_DIR/bin:$APP_BASE_DIR/google-cloud-sdk/bin:$PATH
ENV GOOGLE_APPLICATION_CREDENTIALS="$CREDENTIALS_PATH" \
    CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="$CREDENTIALS_PATH"

# Fix base64 inconsistency
SHELL ["/bin/bash", "-c"]
RUN echo 'base64() { if [[ $@ == "--decode" ]]; then command base64 -d | more; else command base64 "$@"; fi; }' >> $APP_BASE_DIR/home/.bashrc

ARG BUILD_CLOUD_SDK_VERSION
ENV CLOUD_SDK_VERSION="${BUILD_CLOUD_SDK_VERSION}"

WORKDIR $APP_BASE_DIR
RUN curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

ARG BUILD_TERRAFORM_VERSION
ENV TERRAFORM_VERSION="${BUILD_TERRAFORM_VERSION}"

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform $APP_BASE_DIR/bin && \
    terraform --version

ARG BUILD_PROVIDER_GSUITE_VERSION
ENV PROVIDER_GSUITE_VERSION="${BUILD_PROVIDER_GSUITE_VERSION}"

RUN curl -LO https://github.com/DeviaVir/terraform-provider-gsuite/releases/download/v${PROVIDER_GSUITE_VERSION}/terraform-provider-gsuite_${PROVIDER_GSUITE_VERSION}_linux_amd64.tgz && \
    tar xzf terraform-provider-gsuite_${PROVIDER_GSUITE_VERSION}_linux_amd64.tgz && \
    rm terraform-provider-gsuite_${PROVIDER_GSUITE_VERSION}_linux_amd64.tgz && \
    mv terraform-provider-gsuite_v${PROVIDER_GSUITE_VERSION} $APP_BASE_DIR/home/.terraform.d/plugins/terraform-provider-gsuite

WORKDIR $APP_BASE_DIR/workdir
