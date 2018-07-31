PROJECT_NAME := "gonextcloud"
PKG := "github.com/partitio/$(PROJECT_NAME)"
PKG_LIST := $(shell go list ${PKG})
GO_FILES := $(shell find . -name '*.go' | grep -v _test.go)

.PHONY: all dep build clean test coverage coverhtml lint

all: build

lint: ## Lint the files
	@golint -set_exit_status ${PKG_LIST}

test: ## Run unittests
	@go test ${PKG_LIST}

race: dep ## Run data race detector
	@go test -race ${PKG_LIST}

msan: dep ## Run memory sanitizer
	@go test -msan -short ${PKG_LIST}

coverage: ## Generate global code coverage report
	mkdir -p cover
	go tool cover -html=cover/gonextcloud.cov -o coverage.html

dep: ## Get the dependencies
	mkdir -p vendor
	@govendor add +external

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
