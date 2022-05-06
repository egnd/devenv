#!make

MAKEFLAGS += --always-make
PARAM=$(filter-out $@,$(MAKECMDGOALS))

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:

########################################################################################################################

show-tasks: ## Show available ansible tasks
	@ls -A | grep -E "task\..+"

task: ## Run specific ansible task
	@echo "--- run $(PARAM)"
	ansible-playbook --inventory="localhost," \
		-e current_user=$$(id -un) \
		-e current_home=$(HOME) \
		-e repo_loc_pref=$(REPO_PREF) \
		$(PARAM)

deploy: ## Install reqiured software
	@mkdir -p $(HOME)/soft
	@$(MAKE) task task.sys.repos.yml
	@$(MAKE) task task.sys.soft.yml
	@$(MAKE) task task.sys.files.yml
	@$(MAKE) task task.browsers.yml
	@$(MAKE) task task.dev.yml
	@$(MAKE) task task.media.yml
	@$(MAKE) task task.messengers.yml
	@$(MAKE) task task.network.yml
	@$(MAKE) task task.office.yml

update: ## Update system
	sudo apt update
	sudo apt upgrade
	sudo apt autoremove
	pip3 install -U docker docker-compose

##################################################################################################################

_test:
	@ls -lAh $(HOME)/.ssh/config
	@ls -lAh $(HOME)/.ssh/id_rsa
	@ls -lAh $(HOME)/.ssh/id_rsa.pub
	@ls -lAh $(HOME)/.ssh/id_ed25519
	@ls -lAh $(HOME)/.ssh/id_ed25519.pub
	@ls -lAh $(HOME)/soft/postman.tar.gz
	@ls -lAh $(HOME)/soft/telegram.tar.xz
	@which curl
	@which make
	@which ssh-keygen
	@which python3
	@which pip3
	@which sshpass
	@which wget
	@which google-chrome
	@which opera
	@which docker
	@which docker-compose
	@which keepassxc
	@which git
	@which dbeaver-ce
	@which code
	@which gimp
	@which vlc
	@which skypeforlinux
	@which zoom
	@which discord
	@which transmission-gtk
	@which remmina
	@which warp-cli
	@which openconnect
	@which openvpn
	@which libreoffice
	@which xsane
	@echo "All is OK!"

_test-docker:
	docker run --rm -it -w /src --volume "$$(pwd)":"/src":ro --env DEBIAN_FRONTEND=noninteractive \
		ubuntu:22.04 bash -c "apt update > /dev/null && apt install --no-install-recommends -y make ansible && make deploy _test"
