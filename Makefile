SHELL := /bin/bash
REGION := us-east-1
CLUSTER_NAME := eks-dev-cluster-01
KUBESEAL_VERSION := 0.19.1

# Local

.PHONY: config
config:
	@git config --global --add safe.directory '*'

.PHONY: alias
alias:
	@echo "alias k=kubectl" >> ~/.profile
	echo "alias m=make" >> ~/.profile
	source ~/.profile

.PHONY: kubeseal
kubeseal:
	@wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v$(KUBESEAL_VERSION)/kubeseal-$(KUBESEAL_VERSION)-linux-amd64.tar.gz
	tar -xvzf kubeseal-$(KUBESEAL_VERSION)-linux-amd64.tar.gz kubeseal
	sudo install -m 755 kubeseal /usr/local/bin/kubeseal
	rm -rf kubeseal*

.PHONY: update-config
update-config:
	@aws eks update-kubeconfig --region $(REGION) --name $(CLUSTER_NAME)

.DEFAULT_GOAL := config
