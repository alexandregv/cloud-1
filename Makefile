# Export environment variables from .env file
include docker/.env.local
export


# General rules
all: test deploy

deps:
	ansible --version
	ansible-galaxy collection install -r ansible/requirements.yml

re: all


# Ansible rules
test:
	ansible-playbook -i ansible/inventory.yml ansible/playbooks/test.yml

install:
	ansible-playbook -i ansible/inventory.yml ansible/playbooks/docker.yml --tags "install"

deploy:
	@echo ok


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all deps re test install deploy
