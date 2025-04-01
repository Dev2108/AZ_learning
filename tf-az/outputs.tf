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

