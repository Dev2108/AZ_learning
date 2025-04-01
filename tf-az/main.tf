provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.client_id
  client_secret = var.client_secret
}

#Create resource group 
resource "azurerm_resource_group" "terraform_rg" {
  name     = "terraform-rg"
  location = "East US"
}
# Create Key Vault
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

data "azuread_service_principal" "terraformSP" {
  client_id = var.client_id
}

resource "azurerm_key_vault" "terraform_kv" {
  name                = "terraform-kv-${random_string.kv_suffix.result}" 
  location            = azurerm_resource_group.terraform_rg.location
  resource_group_name = azurerm_resource_group.terraform_rg.name
  sku_name                    = "standard"
  tenant_id                   = var.tenant_id
  enable_rbac_authorization   = true
}

module "app_registration" {
  source          = "./modules/app_reg"
  app_name        = var.app_name
  key_vault_id    = azurerm_key_vault.terraform_kv.id
}

module "rbac" {
  source = "./modules/rbac"
  scope  = "/subscriptions/${var.subscription_id}"

  sp_role_assignments = [
    {
      role         = "Contributor"
      principal_id = module.app_registration.service_principal_object_id
    },
    {
      role         = "User Access Administrator"
      principal_id = module.app_registration.service_principal_object_id
    }
  ]
}

module "rbac_kv" {
  source         = "./modules/rbac"
  scope          = azurerm_key_vault.terraform_kv.id  # Fix: Use actual ID, not a string
  sp_role_assignments = [
    {
      role         = "Key Vault Secrets Officer"
      principal_id = data.azuread_service_principal.terraformSP.object_id
    }
  ]
}

