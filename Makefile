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


# database
database.build:
	${DC} build database

database.logs:
	${DC} logs database

database.logsf:
	${DC} logs -f database

database.up:
	${DC} up database

database.upd:
	${DC} up -d database

database.start:
	${DC} start database

database.stop:
	${DC} stop database

database.kill:
	${DC} kill database

database.rm:
	${DC} rm -f database

database.rmv:
	${DC} rm -f -v database
	docker volume rm ${NAME}_database

database.run: database.upd database.logsf

database.down: database.stop database.rm

database.downv: database.stop database.rmv

database.shell:
	${DC} exec database bash

database.shell.root:
	${DC} exec --user 0 database bash

database.client:
	${DC} exec database mariadb -u$${DB_USER} -p$${DB_PASS}

database.client.root:
	if [ -n "$${DB_ROOT_PASS}" ] && [ -z "$${DB_RANDOM_ROOT_PASS}" ]; then \
		${DC} exec database mariadb -uroot -p$${DB_ROOT_PASS}; \
	else \
		${DC} exec database mariadb -uroot -p; \
	fi


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all deps test deploy clean fclean re build up upd ps logs logsf start stop down downv run database.build database.logs database.logsf database.up database.upd database.start database.stop database.kill database.rm database.rmv database.run database.down database.downv database.shell database.shell.root database.client database.client.root
