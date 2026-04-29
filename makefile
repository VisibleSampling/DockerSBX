REGISTRY  = git.honkinwaffles.com
USER      = hw
IMAGE     = claude-code
DATE	  := $(shell date -u +%Y%m%d-%H%M%S)
TAG       ?= $(DATE)
FULL_NAME = $(REGISTRY)/$(USER)/$(IMAGE):$(TAG)
LATEST    = $(REGISTRY)/$(USER)/$(IMAGE):latest

.PHONY: build push tag

build:
	docker build -t $(FULL_NAME) -t $(LATEST) ./claude-code

push: build
	docker push $(FULL_NAME)
	docker push $(LATEST)
	@echo ""
	@echo "Pushed: $(FULL_NAME)"
	@echo "Run with: sbx run --template $(FULL_NAME) claude"

tag:
	@echo $(FULL_NAME)
