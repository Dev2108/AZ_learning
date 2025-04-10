resource "random_password" "passwords" {
  for_each = merge([
    for group, emails in var.users_by_group : {
      for email in emails : "${group}-${email}" => email
    }
  ]...)

  length  = 16
  special = true
}

resource "azuread_user" "users" {
  for_each = merge([
    for group, emails in var.users_by_group : {
      for email in emails : "${group}-${email}" => {
        group = group
        email = email
      }
    }
  ]...)

  user_principal_name = each.value.email
  display_name        = "${split("@", each.value.email)[0]}"
  mail_nickname       = split("@", each.value.email)[0]
  password            = random_password.passwords[each.key].result
}

resource "azuread_group" "user_groups" {
  for_each = toset(keys(var.users_by_group))

  display_name     = each.key          # "developer", "qa"
  security_enabled = true
}

resource "azuread_group_member" "group_members" {
  for_each = {
    for key, user in azuread_user.users : key => {
      group_key = split("-", key)[0]
      user_id   = user.object_id
    }
  }

  group_object_id  = azuread_group.user_groups[each.value.group_key].object_id  # ✅ Use object_id here
  member_object_id = each.value.user_id
}

