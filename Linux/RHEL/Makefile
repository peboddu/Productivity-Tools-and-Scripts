SHELL := /bin/bash
PYTHON2.7_PATH := $(shell which python2.7)
ANSIBLE_ROOT_DIR := $(shell pwd)

## TODO: Change ifneq => ifeq
ifneq ($(USER),eman)
	RUN_AS_USER :=
else
	RUN_AS_USER := sudo -u eman
endif

.PHONY: help
help:
	$(INFO) "NPRD targets:"
	@grep '^.PHONY.*nprd' Makefile | perl -pe 's/^.PHONY: /    make /' | sort -n
	@echo
	$(INFO) "PROD targets:"
	@grep '^.PHONY.*prod' Makefile | perl -pe 's/^.PHONY: /    make /' | sort -n
	@echo
	$(INFO) "ALL targets:"
	@grep '^.PHONY:' Makefile | perl -pe 's/^.PHONY: /    make /' | sort -n

.PHONY: setup-prod-env
setup-prod-env:
	@echo $(ANSIBLE_ROOT_DIR)

.PHONY: setup-nprd-env
setup-nprd-env:
	sudo yum install -y gcc epel-release
	sudo yum install -y python-pip sshpass
	$(PYTHON2.7_PATH) -m pip install --upgrade pip
	$(PYTHON2.7_PATH) -m pip install 'ansible==2.4.3.0'
	$(PYTHON2.7_PATH) -m pip install elasticsearch python-logstash pipenv requests jmespath mysql-connector click tabulate
	sudo mkdir -p /etc/ansible/ /apps/logs/ansible/ $(HOME)/.vault
	sudo ln -s $(ANSIBLE_ROOT_DIR)/ansible.cfg $(HOME)/.ansible.cfg
	sudo echo "Admin-135" > $(HOME)/.vault/vault-pwd.txt

.PHONY: provision-users
provision-users:
	$(RUN_AS_USER) ansible-playbook -i $(ANSIBLE_ROOT_DIR)/inventory $(ANSIBLE_ROOT_DIR)/playbooks/users.yml --check

.PHONY: teardown-nprd-slk
teardown-nprd-slk:
	# To install & configure Nginx as reverse proxy for Kibana & Elasticsearch
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t kibana-reverse-proxy -l nprod-elastickibana-nodes
	# Install Filebeat on nprd source servers
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-filebeat -l nprod-filebeat-nodes
	# Install Logstash
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-logstash -l nprod-logstash-nodes
	# Install ElasticSearch & Kibana on 3 servers and form ElasticSearch cluster for fault tolerance
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-elastickibana -l nprod-elastickibana-nodes

.PHONY: teardown-prod-slk
teardown-prod-slk:
	# To install & configure Nginx as reverse proxy for Kibana & Elasticsearch
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t kibana-reverse-proxy -l prod-elastickibana-nodes
	# Install Filebeat on prod source servers
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-filebeat -l prod-filebeat-nodes
	# Install Logstash
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-logstash -l prod-logstash-nodes
	# Install ElasticSearch & Kibana on 3 servers and form ElasticSearch cluster for fault tolerance
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml --extra-vars "install_state=absent" -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-elastickibana -l prod-elastickibana-nodes

.PHONY: setup-nprd-slk
setup-nprd-slk:
	# Install ElasticSearch & Kibana on 3 servers and form ElasticSearch cluster for fault tolerance
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-elastickibana -l nprod-elastickibana-nodes
	# Install Logstash
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-logstash -l nprod-logstash-nodes
	# Install Filebeat on nprd source servers
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-filebeat -l nprod-filebeat-nodes
	# To install & configure Nginx as reverse proxy for Kibana & Elasticsearch
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t kibana-reverse-proxy -l nprod-elastickibana-nodes

.PHONY: setup-prod-slk
setup-prod-slk:
	# Install ElasticSearch & Kibana on 3 servers and form ElasticSearch cluster for fault tolerance
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-elastickibana -l prod-elastickibana-nodes
	# Install Logstash
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-logstash -l prod-logstash-nodes
	# Install Filebeat on nprd source servers
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t slk-filebeat -l prod-filebeat-nodes
	# To install & configure Nginx as reverse proxy for Kibana & Elasticsearch
	$(RUN_AS_USER) ansible-playbook $(ANSIBLE_ROOT_DIR)/site.yml -i $(ANSIBLE_ROOT_DIR)/inventory -t kibana-reverse-proxy -l prod-elastickibana-nodes

.PHONY: rebuild-<collelctor_fqdn>
rebuild-slc-%:
	$(eval COLLECTOR := $(subst rebuild-,,$@))
	$(RUN_AS_USER) ansible-playbook -i $(ANSIBLE_ROOT_DIR)/inventory $(ANSIBLE_ROOT_DIR)/site.yml -t command-line-user -l $(COLLECTOR)
	$(RUN_AS_USER) ansible-playbook -i $(ANSIBLE_ROOT_DIR)/inventory $(ANSIBLE_ROOT_DIR)/site.yml -t configure-ipv6-address -l $(COLLECTOR)
	$(RUN_AS_USER) ansible-playbook -i $(ANSIBLE_ROOT_DIR)/inventory $(ANSIBLE_ROOT_DIR)/site.yml -t update-resolv-conf -l $(COLLECTOR)
	$(RUN_AS_USER) ansible-playbook -i $(ANSIBLE_ROOT_DIR)/inventory $(ANSIBLE_ROOT_DIR)/site.yml -t settings-chrony -l $(COLLECTOR)
	$(RUN_AS_USER) ansible-playbook -i $(ANSIBLE_ROOT_DIR)/inventory $(ANSIBLE_ROOT_DIR)/site.yml -t collector-ssl-cert-expiry -l $(COLLECTOR)

## Cosmo
YELLOW := "\e[1;33m"
NC := "\e[0m"

## Shell Function
INFO := @bash -c '\
	printf $(YELLOW); \
	echo "=> $$1"; \
	printf $(NC)' VALUE



## Skelton
# Target($@): Dependencies($<)
# 	system commands