PWD ?= pwd_unknown
PROJECT_NAME = $(shell basename $(CURDIR))
ANSIBLE_VERSION ?= 2.9.10
PYTHON_VERSION ?= 3.7.8-slim-buster
PYTHON_VERSION_NUM := $(shell echo ${PYTHON_VERSION} | cut -f1 -d-)
IMAGE_VERSION = "${PYTHON_VERSION_NUM}-${ANSIBLE_VERSION}"

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker Image
	@docker build -t $(PROJECT_NAME):${IMAGE_VERSION} --build-arg ANSIBLE_VERSION --build-arg PYTHON_VERSION .

build-nc: ## Build Docker Image with no cache
	@docker build --no-cache -t $(PROJECT_NAME):${IMAGE_VERSION} --build-arg ANSIBLE_VERSION --build-arg PYTHON_VERSION .

latest: ## Set latest Docker image
	@docker tag $(PROJECT_NAME):${IMAGE_VERSION} $(PROJECT_NAME):latest
	@echo "Latest Docker image version: ${IMAGE_VERSION}"