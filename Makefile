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
CREDENTIALS_PATH ?= /cft/workdir/credentials.json
DOCKER_ORG := gcr.io/cloud-foundation-cicd
DOCKER_TAG_BASE_KITCHEN_TERRAFORM ?= 0.11.10_216.0.0_1.19.1_0.1.10
DOCKER_REPO_BASE_KITCHEN_TERRAFORM := ${DOCKER_ORG}/cft/kitchen-terraform:${DOCKER_TAG_BASE_KITCHEN_TERRAFORM}
DOCKER_TAG_KITCHEN_TERRAFORM ?= ${DOCKER_TAG_BASE_KITCHEN_TERRAFORM}
DOCKER_IMAGE_KITCHEN_TERRAFORM := cft/kitchen-terraform_terraform-google-kubernetes-engine

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

# Integration tests
.PHONY: test_integration
test_integration:
	bundle install
	bundle exec kitchen create
	bundle exec kitchen converge
	bundle exec kitchen converge
	bundle exec kitchen verify
	bundle exec kitchen destroy

.PHONY: generate_docs
generate_docs:
	@source test/make.sh && generate_docs

.PHONY: generate
generate:
	@pip install --user -r ./helpers/generate_modules/requirements.txt
	@./helpers/generate_modules/generate_modules.py

# Versioning
.PHONY: version
version:
	@source helpers/version-repo.sh

# Build Docker
.PHONY: docker_build_kitchen_terraform
docker_build_kitchen_terraform:
	docker build -f build/docker/kitchen_terraform/Dockerfile \
		--build-arg BASE_IMAGE=${DOCKER_REPO_BASE_KITCHEN_TERRAFORM} \
		-t ${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} .

# Push Docker image
.PHONY: docker_push_kitchen_terraform
docker_push_kitchen_terraform:
	docker tag ${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} ${DOCKER_ORG}/${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM}
	docker push ${DOCKER_ORG}/${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM}

# Run docker
.PHONY: docker_run
docker_run:
	docker run --rm -it \
		-e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=${CREDENTIALS_PATH} \
		-e GOOGLE_APPLICATION_CREDENTIALS=${CREDENTIALS_PATH} \
		-v $(CURDIR):/cft/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash

.PHONY: docker_create
docker_create: docker_build_kitchen_terraform
	docker run --rm -it \
		-e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=${CREDENTIALS_PATH} \
		-e GOOGLE_APPLICATION_CREDENTIALS=${CREDENTIALS_PATH} \
		-v $(CURDIR):/cft/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen create"

.PHONY: docker_converge
docker_converge:
	docker run --rm -it \
		-e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=${CREDENTIALS_PATH} \
		-e GOOGLE_APPLICATION_CREDENTIALS=${CREDENTIALS_PATH} \
		-v $(CURDIR):/cft/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen converge && kitchen converge"

.PHONY: docker_verify
docker_verify:
	docker run --rm -it \
		-e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=${CREDENTIALS_PATH} \
		-e GOOGLE_APPLICATION_CREDENTIALS=${CREDENTIALS_PATH} \
		-v $(CURDIR):/cft/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen verify"

.PHONY: docker_destroy
docker_destroy:
	docker run --rm -it \
		-e CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=${CREDENTIALS_PATH} \
		-e GOOGLE_APPLICATION_CREDENTIALS=${CREDENTIALS_PATH} \
		-v $(CURDIR):/cft/workdir \
		${DOCKER_IMAGE_KITCHEN_TERRAFORM}:${DOCKER_TAG_KITCHEN_TERRAFORM} \
		/bin/bash -c "kitchen destroy"

.PHONY: test_integration_docker
test_integration_docker: docker_create docker_converge docker_verify docker_destroy
	@echo "Running test-kitchen tests in docker"
