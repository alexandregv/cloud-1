# Export environment variables from .env file
include docker/.env.local
export


# General rules
all: test install start

deps:	
	@if ! command -v ansible > /dev/null; then \
		echo "\n/!\\ Error: Please install ansible v2.9+\n"; \
		exit 1; \
	fi
	@echo "ansible --version: $$(ansible --version | head -n 1 | cut -d ' ' -f 2)"
	ansible-galaxy collection install -r ansible/requirements.yml

re: all


# Ansible rules
## test.yml playbook
test:
	ansible-playbook -i ansible/inventory.yml ansible/test.yml

ping:
	ansible-playbook -i ansible/inventory.yml ansible/test.yml --tags ping

ip:
	ansible-playbook -i ansible/inventory.yml ansible/test.yml --tags ip

## install.yml playbook
install:
	ansible-playbook -i ansible/inventory.yml ansible/install.yml

sync:
	ansible-playbook -i ansible/inventory.yml ansible/install.yml --tags files

## manage.yml playbook
build:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags build

start:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags start

stop:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags stop

up:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags up

down:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags down

scale:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags scale --extra-vars "scale=${SCALE}"

scale-reset:
	ansible-playbook -i ansible/inventory.yml ansible/manage.yml --tags scale --extra-vars "scale='wordpress=1,phpmyadmin=1,mariadb=1,nginx=1'"


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all re test ping ip install sync build start stop up down scale
