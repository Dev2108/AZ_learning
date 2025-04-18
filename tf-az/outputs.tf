output "app_id" {
  value = module.app_registration.app_id
}

output "sp_id" {
  value = module.app_registration.sp_id
}

output "sp_secret" {
  value = module.app_registration.sp_secret
  sensitive = true
}
output "web_app_url" {
  value = module.webapp.web_app_url
}

output "all_user_credentials" {
  value     = module.aad_users.user_credentials
  sensitive = true
}
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}
