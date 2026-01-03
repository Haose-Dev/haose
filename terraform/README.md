# Azure Infrastructure as Code with Terraform

This directory contains Terraform configurations for managing Azure infrastructure for the haose project.

## Structure

```
terraform/
├── modules/
│   └── resource-group/          # Reusable module for creating resource groups
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/
    ├── dev/                      # Development environment
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── backend.hcl.example
    ├── test/                     # Test environment
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── backend.hcl.example
    └── prod/                     # Production environment
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── backend.hcl.example
```

## Prerequisites

1. **Azure CLI** installed and configured
   ```bash
   az login
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
   ```

2. **Terraform** installed (>= 1.0)
   ```bash
   # Check installation
   terraform version
   ```

3. **Azure Service Principal** (recommended for CI/CD) or use Azure CLI authentication

## Quick Start

### 1. Authenticate with Azure

```bash
# Option 1: Using Azure CLI (for local development)
az login

# Option 2: Using Service Principal (for CI/CD)
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### 2. Set up Terraform State Backend (Optional but Recommended)

Before running Terraform, you should set up an Azure Storage Account to store Terraform state remotely.

```bash
# Create a resource group for Terraform state
az group create --name rg-haose-terraform-state --location "East US"

# Create a storage account (name must be globally unique)
az storage account create \
  --name sthaoseterraform \
  --resource-group rg-haose-terraform-state \
  --location "East US" \
  --sku Standard_LRS

# Create a container for Terraform state
az storage container create \
  --name tfstate \
  --account-name sthaoseterraform
```

Then, for each environment, copy the example backend config and update it:

```bash
cd terraform/environments/dev
cp backend.hcl.example backend.hcl
# Edit backend.hcl with your storage account details
```

### 3. Initialize and Apply Terraform

For each environment (dev, test, prod):

```bash
# Navigate to the environment directory
cd terraform/environments/dev

# Initialize Terraform
terraform init -backend-config=backend.hcl

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Environment-Specific Configuration

Each environment (dev, test, prod) has its own:
- Resource group with environment-specific naming
- Variables and configuration
- Separate Terraform state

### Default Resource Group Names
- **Dev**: `rg-haose-dev`
- **Test**: `rg-haose-test`
- **Prod**: `rg-haose-prod`

You can override these by setting variables:

```bash
terraform apply -var="resource_group_name=rg-haose-dev-custom"
```

## Adding New Resources

To add new Azure resources:

1. **Add to module** (if reusable across environments):
   - Create or update modules in `terraform/modules/`

2. **Add to environment** (if environment-specific):
   - Update the `main.tf` in the respective environment directory
   - Add variables to `variables.tf`
   - Add outputs to `outputs.tf` if needed

## Best Practices

1. **State Management**: Always use remote state (Azure Storage) for team collaboration
2. **Version Control**: Never commit `backend.hcl` files with secrets
3. **Tagging**: All resources are tagged with Environment, Project, and ManagedBy
4. **Review Plans**: Always run `terraform plan` before `terraform apply`
5. **Environment Isolation**: Keep environments separate with different state files

## Common Commands

```bash
# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy resources (use with caution!)
terraform destroy

# Show current state
terraform show

# List resources
terraform state list
```

## Troubleshooting

### Authentication Issues
```bash
# Verify Azure CLI authentication
az account show

# Re-authenticate if needed
az login
```

### State Lock Issues
If Terraform state is locked, you may need to unlock it:
```bash
terraform force-unlock <LOCK_ID>
```

## Next Steps

After creating the resource groups, you can:
1. Add Azure services (App Services, Storage Accounts, Databases, etc.)
2. Set up networking (Virtual Networks, Subnets, etc.)
3. Configure security (Key Vaults, Managed Identities, etc.)
4. Set up monitoring and logging

## Security Notes

- Never commit sensitive values (secrets, keys) to version control
- Use Azure Key Vault for secrets management
- Use Managed Identities instead of service principals where possible
- Enable Azure Policy for compliance and governance

