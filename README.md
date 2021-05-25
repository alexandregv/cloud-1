# cloud-1

Basic cloud project at 42

## Requirements

* Make
* Ansible 2.9+
* [community.docker](https://galaxy.ansible.com/community/docker) ansible-galaxy plugin

## Installation

1. `git clone https://github.com/alexandregv/cloud-1`
2. `cd cloud-1`
3. `make deps`

## Useful commands

Test connection to hosts:  
```bash
ansible -i inventory.yml all -m ping
```
