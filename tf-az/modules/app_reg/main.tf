resource "azuread_application" "terraform_app" {
  display_name = var.app_name
}

resource "azuread_service_principal" "terraform_sp" {
  client_id = azuread_application.terraform_app.client_id
}

resource "azuread_application_password" "terraform_secret" {
  application_id = azuread_application.terraform_app.id
  display_name   = "TerraformSP-Secret"
}

#store SP secret to vault
resource "azurerm_key_vault_secret" "sp_secret" {
  name         = "sp-secret"
  value        = azuread_application_password.terraform_secret.value
  key_vault_id = var.key_vault_id

  depends_on = [azuread_application_password.terraform_secret]
}

