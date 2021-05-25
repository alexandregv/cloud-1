# Export environment variables from .env file
include docker/.env
export


# Variables
NAME=cloud-one
DC=docker-compose -f docker/docker-compose.yaml -p ${NAME}


# General rules
all: test deploy

deps:
	ansible --version
	ansible-galaxy collection install community.docker

test:
	ansible-playbook -i inventory.yml playbooks/test.yml

deploy:
	@echo ok

clean: down

fclean: downv
	if [ -n "$$(${DC} images -q)" ]; then \
		docker image rm $$(${DC} images -q); \
	fi

re: fclean all


# Global docker-compose rules
build:
	${DC} build

up:
	${DC} up

upd:
	${DC} up -d

ps:
	${DC} ps

logs:
	${DC} logs

logsf:
	${DC} logs -f

start:
	${DC} start

stop:
	${DC} stop

down:
	${DC} down

downv:
	${DC} down -v

run: upd logsf


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all deps test deploy clean fclean re build up upd ps logs logsf start stop down downv run
