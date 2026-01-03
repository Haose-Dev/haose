#!/bin/bash
# Script to initialize Terraform backend storage account
# Usage: ./init-backend.sh <environment> [location]
# Example: ./init-backend.sh dev "East US"

set -e

ENVIRONMENT=${1:-dev}
LOCATION=${2:-"East US"}
RESOURCE_GROUP="rg-haose-terraform-state"
STORAGE_ACCOUNT="sthaoseterraform$(openssl rand -hex 3 | tr '[:upper:]' '[:lower:]')"
CONTAINER_NAME="tfstate"

echo "Initializing Terraform backend for environment: $ENVIRONMENT"
echo "Location: $LOCATION"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "Error: Azure CLI is not installed. Please install it first."
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo "Error: Not logged in to Azure. Please run 'az login' first."
    exit 1
fi

# Create resource group if it doesn't exist
echo "Creating resource group: $RESOURCE_GROUP"
az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output none || true

# Create storage account if it doesn't exist
echo "Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --output none || true

# Get storage account key
STORAGE_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query "[0].value" \
  --output tsv)

# Create container if it doesn't exist
echo "Creating container: $CONTAINER_NAME"
az storage container create \
  --name "$CONTAINER_NAME" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --output none || true

# Create backend.hcl file
BACKEND_FILE="../environments/$ENVIRONMENT/backend.hcl"
cat > "$BACKEND_FILE" << EOF
resource_group_name  = "$RESOURCE_GROUP"
storage_account_name = "$STORAGE_ACCOUNT"
container_name       = "$CONTAINER_NAME"
key                  = "$ENVIRONMENT.terraform.tfstate"
EOF

echo ""
echo "Backend configuration created at: $BACKEND_FILE"
echo ""
echo "Next steps:"
echo "1. Review the backend.hcl file"
echo "2. Run: cd ../environments/$ENVIRONMENT"
echo "3. Run: terraform init -backend-config=backend.hcl"
echo "4. Run: terraform plan"
echo "5. Run: terraform apply"

