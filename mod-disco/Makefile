SHARED_FSPATH=./../includes

include $(SHARED_FSPATH)/help.mk
include $(SHARED_FSPATH)/flu.mk

# flu build
override FLU_SAMPLE_NAME =example
override FLU_SAMPLE_FSPATH = $(PWD)/example/client/flu
override FLU_LIB_NAME = mod_disco
override FLU_LIB_FSPATH = $(PWD)/service/flu

EXAMPLE_CFG_DIR = ./bin-all/config
EXAMPLE_MOD_DISCO_DB_ENCRYPT_KEY = mostSuperSecretKeyPlausible34@
EXAMPLE_MOD_DISCO_CFG_PATH = $(EXAMPLE_CFG_DIR)/moddisco.yml

EXAMPLE_SRC_DIR = ./example
SERVER_DIR = $(EXAMPLE_SRC_DIR)/server/go
CLI_DIR =  $(EXAMPLE_SRC_DIR)/cli/go

all: print build

## Print all settings
print: ## print
	@echo -- REPO -- 
	@echo REPOSITORY: $(REPOSITORY)
	@echo
	@booty os-print
	$(MAKE) flu-print
	$(MAKE) flu-gen-lang-print

build: build-delete
	$(MAKE) flu-config
	@echo 'Building example golang binaries (CLI and Server)'
	@mkdir -p bin-all/{cli,client,server}/{go,flu}
	@echo 'Building Golang binaries'
	# Commented Out, Nothing there yet
	@go build -v -o bin-all/cli/go/ ./example/cli/go/main.go
	@go build -v -o bin-all/server/go/ ./example/server/go/main.go
	@echo 'Building flutter binary'
	$(MAKE) flu-web-build
	@#cp -Rv ./example/client/flu/build ./bin-all/client/flu/

build-delete:
	@echo 'Removing built go and flutter binaries'
	rm -rf bin-all/{cli,client,server}/{go,flu}/*

gen-delete:
	@echo 'Removing generated protobuf definition (GO and Flutter)'
	rm -rf service/{flu/lib,go}/rpc/v2/*.{dart,go}

gen: gen-delete config-gen
	@echo "Generating GRPC models and services for Go & Flutter"
	@mkdir -p service/{flu/lib,go}/rpc/v2
	@go generate
	# Flutter langs
	#$(MAKE) flu-gen-all
	#$(MAKE) flu-gen-lang

ex-server-run:
	./bin-all/server/go/main

example-flutter-web-run:
	@echo Running Example Flutter Web Client
	$(MAKE) flu-web-run

example-flutter-desk-run:
	@echo Running Example Flutter Desk Client
	# HAs a bug. Runs, but Desktop screen is black.
	$(MAKE) flu-desk-build

config-gen: config-clean config-dep
	@echo Generating Config
	@mkdir -p $(EXAMPLE_CFG_DIR)
	@booty jsonnet -S $(SERVER_DIR)/moddisco.jsonnet -V MOD_DISCO_DB_ENCRYPT_KEY=$(EXAMPLE_MOD_DISCO_DB_ENCRYPT_KEY) > $(EXAMPLE_MOD_DISCO_CFG_PATH)

config-clean:
	@echo Deleting previously generated config
	rm -rf $(EXAMPLE_MOD_DISCO_CFG_PATH)

config-dep:
	cd $(SERVER_DIR) && booty jb install && booty jb update
	cd service/go && booty jb install && booty jb update
