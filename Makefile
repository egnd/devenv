#!make

MAKEFLAGS += --always-make --no-print-directory
CALL_PARAM=$(filter-out $@,$(MAKECMDGOALS))

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:
##################################################################################################################

owner:
	sudo chown --changes -R $$(whoami) ./
	@echo "Success"

_docker:
	@docker build --build-arg DISTRO_NAME=ubuntu:22.04 --file=.ci/deb.Dockerfile --tag=devenv:deb .ci
	@docker run --rm -it -v "$(PWD)":"/src":ro devenv:deb $(CALL_PARAM)

docker-run:
ifeq (docker-run,$(MAKECMDGOALS))
	@for recipe in recipes/*.yml; do clear && $(MAKE) _docker "run $$recipe" || exit 1; done
else
	@clear
	$(MAKE) _docker "run $(CALL_PARAM)"
endif
	@echo "All is OK!"

docker-install:
ifeq (docker-run,$(MAKECMDGOALS))
	@for rcgroup in "$(CALL_PARAM)"; do clear && $(MAKE) _docker "install-$$rcgroup" || exit 1; done
else
	@clear
	@$(MAKE) _docker "install-$(CALL_PARAM)"
endif
	@echo "All is OK!"

########################################################################################################################

# install-coding: ## Install developer tools
# 	@$(MAKE) run recipes/keypairs.yml
# 	@$(MAKE) run recipes/vpn.yml
# 	@$(MAKE) run recipes/devtools.yml
# 	@$(MAKE) run recipes/postman.yml
# 	@$(MAKE) run recipes/docker.yml
# 	@$(MAKE) run recipes/vscode.yml
# 	@$(MAKE) run recipes/dbeaver.yml

install-guitar: ## Install jackd, digital guitar preamps, etc.
	@$(MAKE) run recipes/kxstudio.yml
	@$(MAKE) run recipes/winehq.yml
	@$(MAKE) run recipes/tonelib-gfx.yml

_debug:
	@$(MAKE) run recipes/debug.yml

########################

_prepare:
ifeq ($(wildcard vars.yml),)
	cp vars.dist.yml vars.yml
endif
	ansible-galaxy install -r requirements.yml

_run: _prepare
	ansible-playbook --extra-vars="@vars.yml" --inventory="localhost," $(PLAYBOOK).yml
_run_sudo: _prepare
	ansible-playbook --extra-vars="@vars.yml" --inventory="localhost," --ask-become-pass $(PLAYBOOK).yml

debug:
	@$(MAKE) PLAYBOOK=${@} _run

install-internet: ## Install browsers and messengers
	@$(MAKE) PLAYBOOK=${@} _run_sudo

install-vpn: ## Install vpn clients
	@$(MAKE) PLAYBOOK=${@} _run_sudo

install-office: ## Install office software
	@$(MAKE) PLAYBOOK=${@} _run_sudo

install-docker: ## Install docker
	@$(MAKE) PLAYBOOK=${@} _run_sudo

install-coding: ## Install coding tools
	@$(MAKE) PLAYBOOK=${@} _run_sudo

# @TODO: wine
# @TODO: music
# @TODO: gaming
# @TODO: selfhosted-client
# @TODO: selfhosted-server
