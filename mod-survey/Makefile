SHARED_FSPATH=./../../shared
BOILERPLATE_FSPATH=$(SHARED_FSPATH)/boilerplate

include $(BOILERPLATE_FSPATH)/help.mk
include $(BOILERPLATE_FSPATH)/os.mk
include $(BOILERPLATE_FSPATH)/gitr.mk
include $(BOILERPLATE_FSPATH)/tool.mk
include $(BOILERPLATE_FSPATH)/flu.mk


override FLU_SAMPLE_NAME = example
override FLU_SAMPLE_FSPATH = $(PWD)/example/client/flu
override FLU_LIB_NAME = mod_survey
override FLU_LIB_FSPATH = $(PWD)/service/flu
override FLU_LANG_LOCALIZATION_DIR = $(FLU_LIB_FSPATH)/lib/pkg/i18n

EXAMPLE_EMAIL = superadmin@getcouragenow.org
EXAMPLE_PASSWORD = superadmin
EXAMPLE_SERVER_ADDRESS = 127.0.0.1:8888

this-all: this-print this-gen this-build
	
## Print all settings
this-print: ## print
	@echo -- REPO -- 
	@echo REPOSITORY: $(REPOSITORY)
	@echo

	$(MAKE) os-print
	
	$(MAKE) flu-print

	$(MAKE) flu-gen-lang-print

	#$(MAKE) srv-print

this-build: this-build-delete
	@echo 'Building example golang binaries (CLI and Server)'
	@mkdir -p bin-all/{cli,client}/{go,flu}
	@echo 'Building Golang binaries'
	# Commented Out, Nothing there yet
	# go build -v -o bin-all/cli/go/ ./example/cli/go/main.go
	@echo 'Building flutter binary'
	$(MAKE) flu-web-build
	@cp -Rv ./example/client/flu/build ./bin-all/client/flu/

this-build-delete:
	@echo 'Removing built go and flutter binaries'
	rm -rf bin-all/{cli,client,server}/{go,flu}/*

this-gen-delete:
	@echo 'Removing generated protobuf definition (GO and Flutter)'
	rm -rf service/{flu/lib,go}/rpc/v2/*.{dart,go}

this-gen: this-gen-delete
	@echo "Generating GRPC models and services for Go & Flutter"
	@mkdir -p service/{flu/lib,go}/rpc/v2
	@go generate
	# Flutter langs
	$(MAKE) flu-gen-all
	$(MAKE) flu-gen-lang

this-example-flutter-web-run:
	@echo Running Example Flutter Web Client
	$(MAKE) flu-web-run

this-example-flutter-desk-run:
	@echo Running Example Flutter Desk Client
	# HAs a bug. Runs, but Desktop screen is black.
	$(MAKE) flu-desk-build
	