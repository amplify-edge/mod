SHARED_FSPATH=./../../shared
BOILERPLATE_FSPATH=$(SHARED_FSPATH)/boilerplate

include $(BOILERPLATE_FSPATH)/help.mk
include $(BOILERPLATE_FSPATH)/os.mk
include $(BOILERPLATE_FSPATH)/gitr.mk
include $(BOILERPLATE_FSPATH)/tool.mk
include $(BOILERPLATE_FSPATH)/flu.mk

# flu build
override FLU_SAMPLE_NAME =example
override FLU_SAMPLE_FSPATH = $(PWD)/example/client/flu
override FLU_LIB_NAME = mod_disco
override FLU_LIB_FSPATH = $(PWD)/service/flu

# go build
override GO_FSPATH:=${PWD}/server/cmd
override GO_BIN_NAME=mod-main
override GO_BUILD_OUT_FSPATH:=${GOPATH}/bin/$(GO_BIN_NAME)
override GO_BUILD_OUT_ALL_FSPATH=${PWD}/server/assets

EXAMPLE_CFG_DIR = ./bin-all/config
EXAMPLE_MOD_DISCO_DB_ENCRYPT_KEY = mostSuperSecretKeyPlausible34@
EXAMPLE_MOD_DISCO_CFG_PATH = $(EXAMPLE_CFG_DIR)/moddisco.yml

EXAMPLE_SRC_DIR = ./example
SERVER_DIR = $(EXAMPLE_SRC_DIR)/server/go
CLI_DIR =  $(EXAMPLE_SRC_DIR)/cli/go


## Print all settings
this-print: ## print
	@echo -- REPO -- 
	@echo REPOSITORY: $(REPOSITORY)
	@echo
	

	$(MAKE) os-print

	$(MAKE) go-print
	
	$(MAKE) flu-print

	$(MAKE) flu-gen-lang-print

this-build: this-build-delete
	@echo 'Building example golang binaries (CLI and Server)'
	@mkdir -p bin-all/{cli,client,server}/{go,flu}
	@echo 'Building Golang binaries'
	# Commented Out, Nothing there yet
	# go build -v -o bin-all/cli/go/ ./example/cli/go/main.go
	go build -v -o bin-all/server/go/ ./example/server/go/main.go
	@echo 'Building flutter binary'
	#$(MAKE) flu-web-build
	@#cp -Rv ./example/client/flu/build ./bin-all/client/flu/

this-build-delete:
	@echo 'Removing built go and flutter binaries'
	rm -rf bin-all/{cli,client,server}/{go,flu}/*

this-gen-delete:
	@echo 'Removing generated protobuf definition (GO and Flutter)'
	rm -rf service/{flu/lib,go}/rpc/v2/*.{dart,go}

this-gen: this-gen-delete this-config-gen
	@echo "Generating GRPC models and services for Go & Flutter"
	@mkdir -p service/{flu/lib,go}/rpc/v2
	@go generate
	# Flutter langs
	# $(MAKE) flu-gen-all
	$(MAKE) flu-gen-lang

this-ex-server-run:
	./bin-all/server/go/main

this-example-flutter-web-run:
	@echo Running Example Flutter Web Client
	$(MAKE) flu-web-run

this-example-flutter-desk-run:
	@echo Running Example Flutter Desk Client
	# HAs a bug. Runs, but Desktop screen is black.
	$(MAKE) flu-desk-build

this-config-gen: this-config-clean this-config-dep
	@echo Generating Config
	@mkdir -p $(EXAMPLE_CFG_DIR)
	jsonnet -S $(SERVER_DIR)/moddisco.jsonnet -V MOD_DISCO_DB_ENCRYPT_KEY=$(EXAMPLE_MOD_DISCO_DB_ENCRYPT_KEY) > $(EXAMPLE_MOD_DISCO_CFG_PATH)

this-config-clean:
	@echo Deleting previously generated config
	rm -rf $(EXAMPLE_MOD_DISCO_CFG_PATH)

this-config-dep:
	cd $(SERVER_DIR) && jb install && jb update
	cd service/go && jb install && jb update
