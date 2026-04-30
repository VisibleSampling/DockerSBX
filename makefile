DATE := $(shell date -u +%Y%m%d-%H%M%S)
TAG  ?= $(DATE)
REGISTRY := git.honkinwaffles.com/hw
.DEFAULT_GOAL := help
.PHONY: build save local show help guard-%

guard-%:
	@test -n "${$*}" || (echo "Error: $* is required — make $(MAKECMDGOALS) $*=<value>"; exit 1)

help:
	@echo "Usage: make <target> TOOL=<tool> ENV=<env>"
	@echo ""
	@echo "Targets:"
	@echo "  build  — build image"
	@echo "  save   — build and save to tar"
	@echo "  local  — build, save, load into sbx"
	@echo "  push   — build and push to registry"
	@echo "  show   — print image name and tar filename"
	@echo ""
	@echo "Examples:"
	@echo "  make build TOOL=claude ENV=core"
	@echo "  make local TOOL=claude ENV=dev"
	@echo "  make push TOOL=claude ENV=core"

build: guard-TOOL guard-ENV
	@test -d ./hw-$(TOOL)-$(ENV) || (echo "Error: ./hw-$(TOOL)-$(ENV) not found"; exit 1)
	docker build --pull -t $(REGISTRY)/$(TOOL)-$(ENV):$(TAG) ./hw-$(TOOL)-$(ENV)

save: build
	docker save $(REGISTRY)/$(TOOL)-$(ENV):$(TAG) -o hw-$(TOOL)-$(ENV)-$(TAG).tar
	@echo "Saved: hw-$(TOOL)-$(ENV)-$(TAG).tar"

local: save
	sbx template load hw-$(TOOL)-$(ENV)-$(TAG).tar
	@echo "Loaded: $(REGISTRY)/$(TOOL)-$(ENV):$(TAG)"

push: build
	docker push $(REGISTRY)/$(TOOL)-$(ENV):$(TAG)

show: guard-TOOL guard-ENV
	@echo "Image:    $(REGISTRY)/$(TOOL)-$(ENV):$(TAG)"
	@echo "Tar file: hw-$(TOOL)-$(ENV)-$(TAG).tar"
