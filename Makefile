.PHONY: default build ~build build-release run release shell clean

default: build ;

IMAGE_VERSION := 1.0.0
IMAGE_USER := marccarre
IMAGE_NAME := hello-rust
IMAGE := $(IMAGE_USER)/$(IMAGE_NAME)
BUILD_IMAGE := marccarre/rust-dev-env:latest
CURRENT_DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

build:
	docker run -ti -v $(CURRENT_DIR):/home/rust $(BUILD_IMAGE) cargo build

~build:
	docker run -ti -v $(CURRENT_DIR):/home/rust $(BUILD_IMAGE) build-continuously.sh

build-release:
	docker run -ti -v $(CURRENT_DIR):/home/rust $(BUILD_IMAGE) cargo build --release
	docker build \
		-t $(IMAGE):latest \
		-t $(IMAGE):$(IMAGE_VERSION) \
		-t quay.io/$(IMAGE):latest \
		-t quay.io/$(IMAGE):$(IMAGE_VERSION) \
		--build-arg=version=$(IMAGE_VERSION) \
		$(CURRENT_DIR)

run: build-release
	@echo "----------------------------------------"
	docker run $(IMAGE):latest
	@echo "----------------------------------------"

release: build-release
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(IMAGE_VERSION)
	docker push quay.io/$(IMAGE):latest
	docker push quay.io/$(IMAGE):$(IMAGE_VERSION)

shell:
	docker run -ti -v $(CURRENT_DIR):/home/rust $(BUILD_IMAGE)

clean:
	docker run -ti -v $(CURRENT_DIR):/home/rust $(BUILD_IMAGE) cargo clean
	-docker rmi -f \
		$(IMAGE):latest \
		$(IMAGE):$(IMAGE_VERSION) \
		quay.io/$(IMAGE):latest \
		quay.io/$(IMAGE):$(IMAGE_VERSION)
