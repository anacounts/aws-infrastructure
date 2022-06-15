.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# first we copy the environment specific backend and .tfvars, remove any existing local state, then run init
init: ## Initializes the terraform remote state backend and pulls the correct environments state.
	@if [ -z $(ENV) ]; then echo "ENV was not set" ; exit 10 ; fi
	@cd terraform \
	&& rm -f backend.tf \
	&& rm -f terraform.tfvars \
	&& cp environments/$(ENV)/* . \
	&& rm -rf .terraform/*.tf* \
	&& terraform init

plan: init ## Runs a plan.
	@cd terraform && terraform plan

apply: init ## Runs apply for a plan (requires confirmation).
	@cd terraform && terraform apply

destroy: init ## Runs destroy for a plan (requires confirmation).
	@cd terraform && terraform destroy
