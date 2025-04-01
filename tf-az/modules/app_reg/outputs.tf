output "app_id" {
  value = azuread_application.terraform_app.client_id
}

output "sp_id" {
  value = azuread_service_principal.terraform_sp.id
}

output "sp_secret" {
  value     = azuread_application_password.terraform_secret.value
  sensitive = true
}
output "service_principal_object_id" {
  description = "The Object ID of the created Service Principal"
  value       = azuread_service_principal.terraform_sp.object_id
}

