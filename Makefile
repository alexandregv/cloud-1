# Export environment variables from .env file
include docker/.env.local
export


# Variables
ANSIBLE=ansible-playbook -i ansible/inventory.yml
ANSIBLE_TEST=${ANSIBLE} ansible/test.yml
ANSIBLE_INSTALL=${ANSIBLE} ansible/install.yml --extra-vars "dest='${DEST}'"
ANSIBLE_MANAGE=${ANSIBLE} ansible/manage.yml --extra-vars "project_src='${PROJECT_SRC}'"


# General rules
all: test install up

deps:	
	@if ! command -v ansible > /dev/null; then \
		echo "\n/!\\ Error: Please install ansible v2.9+\n"; \
		exit 1; \
	fi
	@echo "ansible --version: $$(ansible --version | head -n 1)"
	@find ./ansible/ -type f -name requirements.yml -exec ansible-galaxy install -r {} \;

re: all


# Ansible rules
## test.yml playbook
test:
	${ANSIBLE_TEST}	

ping:
	${ANSIBLE_TEST} --tags ping

ip:
	${ANSIBLE_TEST} --tags ip

## install.yml playbook
install:
	${ANSIBLE} ansible/install.yml

sync:
	--tags files

## manage.yml playbook
build:
	${ANSIBLE_MANAGE} --tags build

start:
	${ANSIBLE_MANAGE} --tags start

stop:
	${ANSIBLE_MANAGE} --tags stop

up:
	${ANSIBLE_MANAGE} --tags up

down:
	${ANSIBLE_MANAGE} --tags down

scale:
	${ANSIBLE_MANAGE} --tags scale --extra-vars "scale=${SCALE}"

scale-reset:
	${ANSIBLE_MANAGE} --tags scale --extra-vars "scale='wordpress=1,phpmyadmin=1,mariadb=1,nginx=1'"


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all re test ping ip install sync build start stop up down scale
