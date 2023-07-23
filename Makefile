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

run: ## Run recipes (use without arguments to see available recipes)
ifeq (run,$(MAKECMDGOALS))
	@echo "--- specify some recipes from the list below:"
	@find recipes -name '*.yml' | sort -d
else
	ansible-galaxy install -r requirements.yml -p recipes/roles
	@for recipe in "$(CALL_PARAM)"; do \
		sudo ansible-playbook --inventory="localhost," -e current_user=$$(id -un) -e current_home=$(HOME) -e repo_loc_pref=$(REPO_PREF) $$recipe || exit 1; \
	done
endif

install-base: ## Install repos and base utils
	@$(MAKE) run recipes/repos.yml recipes/utils.yml

install-internet: ## Install browsers and messengers
	@$(MAKE) run recipes/brave.yml
	@$(MAKE) run recipes/chrome.yml
	@$(MAKE) run recipes/chromium.yml
	@$(MAKE) run recipes/firefox.yml
	@$(MAKE) run recipes/opera.yml
	@$(MAKE) run recipes/lynx.yml
	@$(MAKE) run recipes/discord.yml
	@$(MAKE) run recipes/skype.yml
	@$(MAKE) run recipes/telegram.yml
	@$(MAKE) run recipes/viber.yml
	@$(MAKE) run recipes/zoom.yml

install-office: ## Install libreoffice and scanner tool
	@$(MAKE) run recipes/office.yml

install-coding: ## Install developer tools
	@$(MAKE) run recipes/keypairs.yml
	@$(MAKE) run recipes/vpn.yml
	@$(MAKE) run recipes/devtools.yml
	@$(MAKE) run recipes/postman.yml
	@$(MAKE) run recipes/docker.yml
	@$(MAKE) run recipes/vscode.yml
	@$(MAKE) run recipes/dbeaver.yml

install-guitar: ## Install jackd, digital guitar preamps, etc.
	@$(MAKE) run recipes/kxstudio.yml
	@$(MAKE) run recipes/winehq.yml
	@$(MAKE) run recipes/tonelib-gfx.yml
