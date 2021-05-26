# Export environment variables from .env file
include docker/.env.local
export


# Variables
DC=docker-compose -f docker/docker-compose.yaml -p "$${COMPOSE_PROJECT_NAME}" --env-file docker/.env.local


# General rules
all: test deploy

deps:
	ansible --version
	ansible-galaxy collection install -r ansible/requirements.yml

clean: down

fclean: downv
	@echo "Deleting $${WP_VOLUME_PATH}..."
	sudo rm -rf "$${WP_VOLUME_PATH}"
	docker image rm \
		"$${COMPOSE_PROJECT_NAME}_mariadb" \
		"$${COMPOSE_PROJECT_NAME}_wordpress" \
		"$${COMPOSE_PROJECT_NAME}_nginx" \
		"$${COMPOSE_PROJECT_NAME}_phpmyadmin" 

re: fclean all


# Ansible rules
test:
	ansible-playbook -i ansible/inventory.yml ansible/playbooks/test.yml

install:
	ansible-playbook -i ansible/inventory.yml ansible/playbooks/docker.yml --tags "install"

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


# mariadb
mariadb.build:
	${DC} build mariadb

mariadb.logs:
	${DC} logs mariadb

mariadb.logsf:
	${DC} logs -f mariadb

mariadb.up:
	${DC} up mariadb

mariadb.upd:
	${DC} up -d mariadb

mariadb.start:
	${DC} start mariadb

mariadb.stop:
	${DC} stop mariadb

mariadb.kill:
	${DC} kill mariadb

mariadb.rm:
	${DC} rm -f mariadb

mariadb.rmv:
	${DC} rm -f -v mariadb
	docker volume rm "$${COMPOSE_PROJECT_NAME}_mariadb" || true

mariadb.run: mariadb.upd mariadb.logsf

mariadb.down: mariadb.stop mariadb.rm

mariadb.downv: mariadb.stop mariadb.rmv

mariadb.shell:
	${DC} exec mariadb sh

mariadb.shell.root:
	${DC} exec --user 0 mariadb sh

mariadb.client:
	${DC} exec mariadb mariadb --socket=/var/lib/mysql/mysql.sock


# nginx
nginx.build:
	${DC} build nginx

nginx.logs:
	${DC} logs nginx

nginx.logsf:
	${DC} logs -f nginx

nginx.up:
	${DC} up nginx

nginx.upd:
	${DC} up -d nginx

nginx.start:
	${DC} start nginx

nginx.stop:
	${DC} stop nginx

nginx.kill:
	${DC} kill nginx

nginx.rm:
	${DC} rm -f nginx

nginx.rmv:
	${DC} rm -f -v nginx

nginx.run: nginx.upd nginx.logsf

nginx.down: nginx.stop nginx.rm

nginx.downv: nginx.stop nginx.rmv

nginx.shell:
	${DC} exec nginx sh

nginx.shell.root:
	${DC} exec --user 0 nginx sh


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
	docker volume rm "$${COMPOSE_PROJECT_NAME}_wordpress" || true

wordpress.run: wordpress.upd wordpress.logsf

wordpress.down: wordpress.stop wordpress.rm

wordpress.downv: wordpress.stop wordpress.rmv

wordpress.shell:
	${DC} exec wordpress sh

wordpress.shell.root:
	${DC} exec --user 0 wordpress sh

wordpress.client:
	@${DC} exec wordpress sh -c "echo 'wp-cli cli info' && wp-cli cli info && echo '=> Use \`wp-cli\` to control this WordPress installation' && exec sh"


# phpmyadmin
phpmyadmin.build:
	${DC} build phpmyadmin

phpmyadmin.logs:
	${DC} logs phpmyadmin

phpmyadmin.logsf:
	${DC} logs -f phpmyadmin

phpmyadmin.up:
	${DC} up phpmyadmin

phpmyadmin.upd:
	${DC} up -d phpmyadmin

phpmyadmin.start:
	${DC} start phpmyadmin

phpmyadmin.stop:
	${DC} stop phpmyadmin

phpmyadmin.kill:
	${DC} kill phpmyadmin

phpmyadmin.rm:
	${DC} rm -f phpmyadmin

phpmyadmin.rmv:
	${DC} rm -f -v phpmyadmin
	docker volume rm "$${COMPOSE_PROJECT_NAME}_phpmyadmin" || true

phpmyadmin.run: phpmyadmin.upd phpmyadmin.logsf

phpmyadmin.down: phpmyadmin.stop phpmyadmin.rm

phpmyadmin.downv: phpmyadmin.stop phpmyadmin.rmv

phpmyadmin.shell:
	${DC} exec phpmyadmin sh

phpmyadmin.shell.root:
	${DC} exec --user 0 phpmyadmin sh


# PHONY
genphony:
	echo .PHONY: $$(grep -E '^[A-Za-z\.]+:[A-Za-z\. ]*$$' Makefile | cut -d: -f1 | grep -vi phony) >> Makefile
.PHONY: all deps clean fclean re test install deploy build up upd ps logs logsf start stop down downv run mariadb.build mariadb.logs mariadb.logsf mariadb.up mariadb.upd mariadb.start mariadb.stop mariadb.kill mariadb.rm mariadb.rmv mariadb.run mariadb.down mariadb.downv mariadb.shell mariadb.shell.root mariadb.client nginx.build nginx.logs nginx.logsf nginx.up nginx.upd nginx.start nginx.stop nginx.kill nginx.rm nginx.rmv nginx.run nginx.down nginx.downv nginx.shell nginx.shell.root wordpress.build wordpress.logs wordpress.logsf wordpress.up wordpress.upd wordpress.start wordpress.stop wordpress.kill wordpress.rm wordpress.rmv wordpress.run wordpress.down wordpress.downv wordpress.shell wordpress.shell.root wordpress.client phpmyadmin.build phpmyadmin.logs phpmyadmin.logsf phpmyadmin.up phpmyadmin.upd phpmyadmin.start phpmyadmin.stop phpmyadmin.kill phpmyadmin.rm phpmyadmin.rmv phpmyadmin.run phpmyadmin.down phpmyadmin.downv phpmyadmin.shell phpmyadmin.shell.root
