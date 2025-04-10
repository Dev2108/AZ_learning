terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.99.0" # or latest available
    }
  }
}

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

module "aad_users" {
  source           = "./modules/aad_user"
  users_by_group   = var.users_by_group
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
 
  # Role assignments for groups
  group_role_assignments = [
    {
      role         = "Contributor"
      principal_id = module.aad_users.group_ids["developer"]
    },
    {
      role         = "Reader"
      principal_id = module.aad_users.group_ids["developer"]
    },
    {
      role         = "Reader"
      principal_id = module.aad_users.group_ids["qa"]
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

module "webapp" {
  source              = "./modules/web_app"
  resource_group_name = "flask-rg"
  location            = "Central US"
  web_app_name        = "flask-webapp-demo1eeg4yuhghyu"
  app_service_plan    = "flask-service-plan"

  sku_name          = "F1"
  python_version      = "3.10"
}

