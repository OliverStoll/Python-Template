
#######################      Variables      #######################

# Load variables from .env file
ifneq ("$(wildcard .env)","")
  include .env
  export
endif

# project
VENV_DIR ?= .venv

ifeq ($(OS),Windows_NT)
    VENV_PYTHON = $(VENV_DIR)/Scripts/python.exe
    PIP = $(VENV_DIR)/Scripts/pip.exe
    POETRY = $(VENV_DIR)/Scripts/poetry.exe
else
    VENV_PYTHON = $(VENV_DIR)/bin/python
    PIP = $(VENV_DIR)/bin/pip
    POETRY = $(VENV_DIR)/bin/poetry
endif



# gcloud
GCLOUD_REGION ?= us-west1
MEMORY ?= 1Gi
DOCKERFILE_PATH ?= ./docker
SERVICES ?= $(GCLOUD_RUN_SERVICES)



#######################      Commands      #######################

.PHONY: init

# Create the virtual environment only when its interpreter is missing
$(VENV_PYTHON):
	python -m venv $(VENV_DIR)

init: $(VENV_PYTHON)
	$(PIP) install poetry
	$(POETRY) env use $(VENV_PYTHON)
	$(POETRY) lock
	$(POETRY) install --no-root
	$(POETRY) run pre-commit install --hook-type pre-commit --hook-type commit-msg




######   GCP Deployment

full-deploy: list-vars auth-docker build push deploy


list-vars:
	@echo "GCLOUD_REGION: $(GCLOUD_REGION)"
	@echo "GCLOUD_PROJECT_ID: $(GCLOUD_PROJECT_ID)"
	@echo "GCLOUD_ARTIFACT_REPO: $(GCLOUD_ARTIFACT_REPO)"
	@echo "MEMORY: $(MEMORY)"
	@echo "DOCKERFILE_PATH: $(DOCKERFILE_PATH)"
	@echo "SERVICES: $(SERVICES)"


# Authenticate docker for google artifact server
auth-docker:
	gcloud auth configure-docker $(GCLOUD_REGION)-docker.pkg.dev


# Build target
build:
	$(foreach service, $(SERVICES), \
		docker build -t $(GCLOUD_REGION)-docker.pkg.dev/$(GCLOUD_PROJECT_ID)/$(GCLOUD_ARTIFACT_REPO)/$(service):latest \
		-f $(DOCKERFILE_PATH)/Dockerfile-$(service) .)


# Run target
run:
	$(foreach service, $(SERVICES), \
		docker run -p 8080:8080 $(GCLOUD_REGION)-docker.pkg.dev/$(GCLOUD_PROJECT_ID)/$(GCLOUD_ARTIFACT_REPO)/$(service):latest)


# Push target
push:
	$(foreach service, $(SERVICES), \
		docker push $(GCLOUD_REGION)-docker.pkg.dev/$(GCLOUD_PROJECT_ID)/$(GCLOUD_ARTIFACT_REPO)/$(service):latest)


# Deploy target
deploy:
	$(foreach service, $(SERVICES), \
		gcloud run deploy $(service) --allow-unauthenticated \
		--image=$(GCLOUD_REGION)-docker.pkg.dev/$(GCLOUD_PROJECT_ID)/$(GCLOUD_ARTIFACT_REPO)/$(service):latest \
		--region=$(GCLOUD_REGION) --project=$(GCLOUD_PROJECT_ID) --memory=$(MEMORY))

