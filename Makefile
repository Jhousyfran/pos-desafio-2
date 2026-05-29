SHELL := /bin/bash

INFRA_DIR := infra
TF := terraform -chdir=$(INFRA_DIR)

.PHONY: help tf-init apply-safe destroy-safe destroy-final destroy-check

help:
	@echo "Targets:"
	@echo "  make tf-init        - terraform init em infra/"
	@echo "  make apply-safe     - apply com protecoes para ArgoCD/ClusterSecretStore"
	@echo "  make destroy-safe   - teardown em 2 fases (recomendado)"
	@echo "  make destroy-final  - destroy direto (usa estado atual)"
	@echo "  make destroy-check  - lista recursos ainda no state"

tf-init:
	$(TF) init

# Aplica configuracao com protecoes para reduzir erros de bootstrap/destroy.
apply-safe:
	$(TF) apply -auto-approve \
		-var='enable_argocd_apps=false' \
		-var='enable_external_secrets_cluster_store=false'
	$(TF) apply -auto-approve

# Fluxo recomendado de teardown para evitar bloqueios de providers/webhooks.
destroy-safe:
	$(TF) apply -auto-approve \
		-var='enable_argocd_apps=false' \
		-var='enable_external_secrets_cluster_store=false'
	$(TF) destroy -auto-approve \
		-var='enable_argocd_apps=false' \
		-var='enable_external_secrets_cluster_store=false'

destroy-final:
	$(TF) destroy -auto-approve

destroy-check:
	$(TF) state list

