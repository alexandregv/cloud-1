NAME=cloud-one

all: test deploy

deps:
	ansible --version
	ansible-galaxy collection install community.docker

test:
	ansible-playbook -i inventory.yml playbooks/test.yml

deploy:
	@echo ok
