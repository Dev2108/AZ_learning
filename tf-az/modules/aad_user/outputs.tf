output "user_credentials" {
  value = {
    for k, u in azuread_user.users : k => {
      email    = u.user_principal_name
      password = random_password.passwords[k].result
    }
  }
  sensitive = true
}

output "group_ids" {
  value = {
    for group, g in azuread_group.user_groups : group => g.object_id
  }
}

