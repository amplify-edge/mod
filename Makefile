
SHARED_FSPATH=./../shared
BOILERPLATE_FSPATH=$(SHARED_FSPATH)/boilerplate

include $(BOILERPLATE_FSPATH)/help.mk
include $(BOILERPLATE_FSPATH)/os.mk
include $(BOILERPLATE_FSPATH)/gitr.mk
include $(BOILERPLATE_FSPATH)/tool.mk
include $(BOILERPLATE_FSPATH)/flu.mk
include $(BOILERPLATE_FSPATH)/go.mk



# remove the "v" prefix
VERSION ?= $(shell echo $(TAGGED_VERSION) | cut -c 2-)

override FLU_SAMPLE_NAME =client
override FLU_LIB_NAME =client

this-all: this-print this-dep this-build this-print-end

## Print all settings
this-print: 
	@echo
	@echo "-- MOD : start --"
	@echo

## Print all settings
this-print-all: ## print
	
	$(MAKE) os-print
	
	$(MAKE) gitr-print

	$(MAKE) go-print

	$(MAKE) tool-print
	
	$(MAKE) flu-print

	$(MAKE) flu-gen-lang-print

this-print-end:
	@echo
	@echo "-- MOD : end --"
	@echo
	@echo
	
this-dep:
	cd $(SHARED_FSPATH) && $(MAKE) this-all


this-build: mod-account-build #mod-disco-build

mod-account-build:
	cd ./mod-account && $(MAKE) this-build

mod-disco-build:
	cd ./mod-disco && $(MAKE) this-build


mod-account-flu-desk-run:
	cd ./mod-account && $(MAKE) flu-desk-run

mod-disco-flu-web-run:
	cd ./mod-disco && $(MAKE) flu-web-run
