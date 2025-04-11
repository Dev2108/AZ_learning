terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "devtfstateaccount91981"     # must be globally unique
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

