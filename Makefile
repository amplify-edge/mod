# Download Booty
BOOTY_URL := https://raw.githubusercontent.com/amplify-edge/booty/master/scripts

ifeq ($(OS),Windows_NT)
	BOOTY_URL:=$(BOOTY_URL)/install.ps1
else
	BOOTY_URL:=$(BOOTY_URL)/install.sh
endif

SHELLCMD :=
ADD_PATH :=
ifeq ($(OS),Windows_NT)
	SHELLCMD:=powershell -NoLogo -Sta -NoProfile -NonInteractive -ExecutionPolicy Unrestricted -Command "Invoke-WebRequest -useb $(BOOTY_URL) | Invoke-Expression"
	ADD_PATH:=export PATH=$$PATH:"/C/booty" # workaround for github CI
else
	SHELLCMD:=curl -fsSL $(BOOTY_URL) | bash
	ADD_PATH:=echo $$PATH
endif

# remove the "v" prefix
VERSION ?= $(shell echo $(TAGGED_VERSION) | cut -c 2-)

override FLU_SAMPLE_NAME =client
override FLU_LIB_NAME =client

all: print dep build print-end

## Print all settings
print:
	@echo
	@echo "-- MOD : start --"
	@echo

## Print all settings
print-all: ## print
	@booty os-print
	@booty gw-print
	$(MAKE) flu-print
	$(MAKE) flu-gen-lang-print

print-end:
	@echo
	@echo "-- MOD : end --"
	@echo
	@echo
	
dep:
	$(SHELLCMD)
	$(ADD_PATH)
	@booty install-all
	@booty extract includes
	$(MAKE) flu-config

build: mod-disco-build

mod-disco-build:
	cd ./mod-disco && $(MAKE) all

mod-disco-flu-web-run:
	cd ./mod-disco && $(MAKE) flu-web-run
