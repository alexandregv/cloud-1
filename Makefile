# Export environment variables from .env file
include docker/.env
export


# Variables
COMPOSE_PROJECT_NAME=cloud-one
DC=docker-compose -f docker/docker-compose.yaml -p ${COMPOSE_PROJECT_NAME}


# General rules
all: test deploy

deps:
	ansible --version
	ansible-galaxy collection install -r ansible/requirements.yml

clean: down

fclean: downv
	if [ -n "$$(${DC} images -q)" ]; then \
		docker image rm $$(${DC} images -q); \
	fi

re: fclean all


# Ansible rules
test:
	ansible-playbook -i ansible/inventory.yml ansible/playbooks/test.yml

deploy:
	@echo ok


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
	docker volume rm ${COMPOSE_PROJECT_NAME}_database

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

# wordpress
wordpress.build:
	${DC} build wordpress

wordpress.logs:
	${DC} logs wordpress

wordpress.logsf:
	${DC} logs -f wordpress

wordpress.up:
	${DC} up wordpress

wordpress.upd:
	${DC} up -d wordpress

wordpress.start:
	${DC} start wordpress

wordpress.stop:
	${DC} stop wordpress

wordpress.kill:
	${DC} kill wordpress

wordpress.rm:
	${DC} rm -f wordpress

wordpress.rmv:
	${DC} rm -f -v wordpress
	docker volume rm ${COMPOSE_PROJECT_NAME}_wordpress

wordpress.run: wordpress.upd wordpress.logsf

wordpress.down: wordpress.stop wordpress.rm

wordpress.downv: wordpress.stop wordpress.rmv

wordpress.shell:
	${DC} exec wordpress bash

wordpress.shell.root:
	${DC} exec --user 0 wordpress bash

# proxy
proxy.build:
	${DC} build proxy

proxy.logs:
	${DC} logs proxy

proxy.logsf:
	${DC} logs -f proxy

proxy.up:
	${DC} up proxy

proxy.upd:
	${DC} up -d proxy

proxy.start:
	${DC} start proxy

proxy.stop:
	${DC} stop proxy

proxy.kill:
	${DC} kill proxy

proxy.rm:
	${DC} rm -f proxy

proxy.rmv:
	${DC} rm -f -v proxy

proxy.run: proxy.upd proxy.logsf

proxy.down: proxy.stop proxy.rm

proxy.downv: proxy.stop proxy.rmv

proxy.shell:
	${DC} exec proxy ash

proxy.shell.root:
	${DC} exec --user 0 proxy ash

# database-ui
database-ui.build:
	${DC} build database-ui

database-ui.logs:
	${DC} logs database-ui

database-ui.logsf:
	${DC} logs -f database-ui

database-ui.up:
	${DC} up database-ui

database-ui.upd:
	${DC} up -d database-ui

database-ui.start:
	${DC} start database-ui

database-ui.stop:
	${DC} stop database-ui

database-ui.kill:
	${DC} kill database-ui

database-ui.rm:
	${DC} rm -f database-ui

database-ui.rmv:
	${DC} rm -f -v database-ui

database-ui.run: database-ui.upd database-ui.logsf

database-ui.down: database-ui.stop database-ui.rm

database-ui.downv: database-ui.stop database-ui.rmv

database-ui.shell:
	${DC} exec database-ui bash

database-ui.shell.root:
	${DC} exec --user 0 database-ui bash


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all deps test deploy clean fclean re build up upd ps logs logsf start stop down downv run database.build database.logs database.logsf database.up database.upd database.start database.stop database.kill database.rm database.rmv database.run database.down database.downv database.shell database.shell.root database.client database.client.root wordpress.build wordpress.logs wordpress.logsf wordpress.up wordpress.upd wordpress.start wordpress.stop wordpress.kill wordpress.rm wordpress.rmv wordpress.run wordpress.down wordpress.downv wordpress.shell wordpress.shell.root proxy.build proxy.logs proxy.logsf proxy.up proxy.upd proxy.start proxy.stop proxy.kill proxy.rm proxy.rmv proxy.run proxy.down proxy.downv proxy.shell proxy.shell.root
