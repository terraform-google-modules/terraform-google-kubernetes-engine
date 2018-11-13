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

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

# Docker build config variables
BUILD_TERRAFORM_VERSION ?= 0.11.10
BUILD_CLOUD_SDK_VERSION ?= 216.0.0
BUILD_PROVIDER_GOOGLE_VERSION ?= 1.17.1
BUILD_PROVIDER_GSUITE_VERSION ?= 0.1.8
DOCKER_IMAGE_TERRAFORM := cftk/terraform
DOCKER_TAG_TERRAFORM ?= ${BUILD_TERRAFORM_VERSION}_${BUILD_CLOUD_SDK_VERSION}_${BUILD_PROVIDER_GOOGLE_VERSION}_${BUILD_PROVIDER_GSUITE_VERSION}
BUILD_RUBY_VERSION := 2.4.2
DOCKER_IMAGE_KITCHEN_TERRAFORM := cftk/kitchen_terraform
DOCKER_TAG_KITCHEN_TERRAFORM ?= ${BUILD_TERRAFORM_VERSION}_${BUILD_CLOUD_SDK_VERSION}_${BUILD_PROVIDER_GOOGLE_VERSION}_${BUILD_PROVIDER_GSUITE_VERSION}
TEST_CONFIG_FILE_LOCATION := "./test/fixtures/config.sh"

# All is the first target in the file so it will get picked up when you just run 'make' on its own
all: check_shell check_python check_golang check_terraform check_docker check_base_files test_check_headers check_headers check_trailing_whitespace generate_docs

# The .PHONY directive tells make that this isn't a real target and so
# the presence of a file named 'check_shell' won't cause this target to stop
# working
.PHONY: check_shell
check_shell:
	@source test/make.sh && check_shell

.PHONY: check_python
check_python:
	@source test/make.sh && check_python

.PHONY: check_golang
check_golang:
	@source test/make.sh && golang

.PHONY: check_terraform
check_terraform:
	@source test/make.sh && check_terraform

.PHONY: check_docker
check_docker:
	@source test/make.sh && docker

.PHONY: check_base_files
check_base_files:
	@source test/make.sh && basefiles

.PHONY: check_shebangs
check_shebangs:
	@source test/make.sh && check_bash

.PHONY: check_trailing_whitespace
check_trailing_whitespace:
	@source test/make.sh && check_trailing_whitespace

.PHONY: test_check_headers
test_check_headers:
	@echo "Testing the validity of the header check"
	@python test/test_verify_boilerplate.py

.PHONY: check_headers
check_headers:
	@echo "Checking file headers"
	@python test/verify_boilerplate.py

.PHONY: generate_docs
generate_docs:
	@source test/make.sh && generate_docs

# Integration tests

.PHONY: regional_test_integration
regional_test_integration:
	./test/integration/gcloud/run.sh regional

.PHONY: zonal_test_integration
zonal_test_integration:
	./test/integration/gcloud/run.sh zonal

.PHONY: test_integration
test_integration: regional_test_integration zonal_test_integration
	@echo "Running tests for regional and zonal clusters"
