# Env Vars
DOCKER_REGISTRY_DOMAIN ?= ghcr.io
DOCKER_OWNER ?= kloud-cnf
DOCKER_IMAGE_NAME := semantic-release
IMAGE_FQDN := $(DOCKER_REGISTRY_DOMAIN)/$(DOCKER_OWNER)/$(DOCKER_IMAGE_NAME)
IMAGE_TAG ?= latest

# Validate input value for registry user
.check-registry-user:
	@test $${DOCKER_REGISTRY_USER?Please set environment variable DOCKER_REGISTRY_USER}

# Validate input value for access token
.check-registry-token:
	@test $${PAT?Please set environment variable PAT}

help:
	@printf "Usage: make [target] \nTargets:\n"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install pre-commit hooks
	@pre-commit install
	@pre-commit gc

uninstall: ## Uninstall hooks
	@pre-commit uninstall

validate: ## Validate files with pre-commit hooks
	@pre-commit run --all-files

clean: ## Clean build files
	$(info Make: running docker prune...)
	@docker system prune --volumes --force

build: ## Build service image
	$(info Make: building image...)
	@DOCKER_BUILDKIT=1 docker build . -t $(IMAGE_FQDN):$(IMAGE_TAG) --no-cache --platform linux/amd64 --platform linux/arm64

run: .check-registry-token ## Run image locally
	$(info Make: running $(IMAGE_FQDN):$(IMAGE_TAG)...)
	@docker run -it --rm \
		-e GITHUB_TOKEN=$(PAT) \
		-v $(shell pwd)/:/app:rw \
		-w /app \
		$(IMAGE_FQDN):$(IMAGE_TAG) "semantic-release --help"

push: ## Push service image to registry
	$(info Make: pushing image...)
	@docker push $(IMAGE_FQDN):$(IMAGE_TAG)

login: .check-registry-user .check-registry-token ## login to registry
	$(info Make: Logging into $(DOCKER_REGISTRY_DOMAIN).)
	@echo $(PAT) | docker login $(DOCKER_REGISTRY_DOMAIN) -u $(DOCKER_REGISTRY_USER) --password-stdin

run-fresh: build run ## Build fresh image and run it

publish: login build push ## Login to registry, build fresh image and push it

# Example local commands
# DOCKER_REGISTRY_USER=kolvin PAT=$(op item get "GH_PAT_kolvin" --fields credential) make login
# DOCKER_REGISTRY_USER=kolvin PAT=$(op item get "GH_PAT_kolvin" --fields credential) IMAGE_TAG=local make publish
# PAT=$(op item get "GH_PAT_kolvin" --fields credential) IMAGE_TAG=local make run-fresh
# PAT=$(op item get "GH_PAT_kolvin" --fields credential) IMAGE_TAG=local make run
