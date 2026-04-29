DATE := $(shell date -u +%Y%m%d-%H%M%S)
TAG  ?= $(DATE)

.DEFAULT_GOAL := help
.PHONY: build save local show help guard-%

guard-%:
	@test -n "${$*}" || (echo "Error: $* is required — make $(MAKECMDGOALS) $*=<value>"; exit 1)

help:
	@echo "Usage: make <target> TOOL=<tool> ENV=<env>"
	@echo ""
	@echo "Targets:"
	@echo "  build  — build image"
	@echo "  save   — build and save to tar file"
	@echo "  local  — build, save, and load into sbx"
	@echo "  show   — print image name and tar filename"
	@echo ""
	@echo "Examples:"
	@echo "  make build TOOL=claude ENV=core"
	@echo "  make local TOOL=claude ENV=dev"

build: guard-TOOL guard-ENV
	@test -d ./hw-$(TOOL)-$(ENV) || (echo "Error: ./hw-$(TOOL)-$(ENV) not found — check TOOL and ENV values"; exit 1)
	docker build --pull -t hw-$(TOOL)-$(ENV):$(TAG) ./hw-$(TOOL)-$(ENV)

save: build
	docker save hw-$(TOOL)-$(ENV):$(TAG) -o hw-$(TOOL)-$(ENV)-$(TAG).tar
	@echo "Saved: hw-$(TOOL)-$(ENV)-$(TAG).tar"

local: save
	sbx template load hw-$(TOOL)-$(ENV)-$(TAG).tar
	@echo
	@echo "Loaded: hw-$(TOOL)-$(ENV):$(TAG)"

show: guard-TOOL guard-ENV
	@echo "Image:    hw-$(TOOL)-$(ENV):$(TAG)"
	@echo "Tar file: hw-$(TOOL)-$(ENV)-$(TAG).tar"
