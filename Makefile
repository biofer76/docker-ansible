IMAGE          ?= particles/ansible
ANSIBLE_VERSION ?= $(shell grep 'ARG ANSIBLE_VERSION' Dockerfile | cut -d'"' -f2)
PYTHON_VERSION  ?= $(shell grep 'ARG PYTHON_VERSION' Dockerfile | cut -d= -f2)
TAG            ?= local

.DEFAULT_GOAL := help

.PHONY: build test shell version clean push help

build: ## Build the Docker image locally
	docker build \
		--build-arg ANSIBLE_VERSION=$(ANSIBLE_VERSION) \
		--build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
		-t $(IMAGE):$(TAG) .

test: build ## Build and run the example playbook
	ANSIBLE_IMAGE=$(IMAGE):$(TAG) ./ansible playbook examples/playbook-test.yml

shell: build ## Open an interactive shell in the container
	docker run --rm -it \
		-v "$(PWD)":/ansible \
		-v "$(HOME)/.ssh":/root/.ssh:ro \
		-v "$(HOME)/.ansible":/root/.ansible \
		--network host \
		--entrypoint /bin/sh \
		$(IMAGE):$(TAG)

version: build ## Print the Ansible version installed in the image
	docker run --rm $(IMAGE):$(TAG)

clean: ## Remove the local image
	docker rmi $(IMAGE):$(TAG) 2>/dev/null || true

push: ## Push the image to Docker Hub
	docker push $(IMAGE):$(TAG)

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*##"}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'
