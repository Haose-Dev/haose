.PHONY: help init plan apply destroy validate fmt clean

# Default environment
ENV ?= dev

help: ## Show this help message
	@echo "Usage: make [target] [ENV=environment]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "Environments: dev, test, prod"
	@echo "Example: make plan ENV=dev"

init: ## Initialize Terraform for the specified environment
	@echo "Initializing Terraform for environment: $(ENV)"
	cd environments/$(ENV) && terraform init

init-backend: ## Initialize Terraform with backend configuration
	@echo "Initializing Terraform with backend for environment: $(ENV)"
	cd environments/$(ENV) && terraform init -backend-config=backend.hcl

plan: ## Run terraform plan for the specified environment
	@echo "Planning changes for environment: $(ENV)"
	cd environments/$(ENV) && terraform plan

apply: ## Apply Terraform changes for the specified environment
	@echo "Applying changes for environment: $(ENV)"
	cd environments/$(ENV) && terraform apply

apply-auto: ## Apply Terraform changes automatically (use with caution)
	@echo "Applying changes automatically for environment: $(ENV)"
	cd environments/$(ENV) && terraform apply -auto-approve

destroy: ## Destroy infrastructure for the specified environment
	@echo "WARNING: This will destroy all resources in $(ENV) environment!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd environments/$(ENV) && terraform destroy; \
	fi

validate: ## Validate Terraform configuration
	@echo "Validating Terraform configuration for environment: $(ENV)"
	cd environments/$(ENV) && terraform validate

fmt: ## Format Terraform files
	@echo "Formatting Terraform files"
	terraform fmt -recursive

fmt-check: ## Check if Terraform files are formatted
	@echo "Checking Terraform file formatting"
	terraform fmt -check -recursive

clean: ## Clean Terraform files (.terraform directory and .terraform.lock.hcl)
	@echo "Cleaning Terraform files for environment: $(ENV)"
	cd environments/$(ENV) && rm -rf .terraform .terraform.lock.hcl

clean-all: ## Clean Terraform files for all environments
	@echo "Cleaning Terraform files for all environments"
	find environments -type d -name .terraform -exec rm -rf {} + 2>/dev/null || true
	find environments -type f -name .terraform.lock.hcl -delete 2>/dev/null || true

show: ## Show current Terraform state
	@echo "Showing Terraform state for environment: $(ENV)"
	cd environments/$(ENV) && terraform show

output: ## Show Terraform outputs
	@echo "Showing outputs for environment: $(ENV)"
	cd environments/$(ENV) && terraform output

# Initialize all environments
init-all: ## Initialize all environments
	@echo "Initializing all environments..."
	@for env in dev test prod; do \
		echo "Initializing $$env..."; \
		cd environments/$$env && terraform init && cd ../..; \
	done

# Plan all environments
plan-all: ## Plan changes for all environments
	@echo "Planning changes for all environments..."
	@for env in dev test prod; do \
		echo "Planning $$env..."; \
		cd environments/$$env && terraform plan && cd ../..; \
	done

