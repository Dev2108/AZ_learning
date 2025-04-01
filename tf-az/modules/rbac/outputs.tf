output "sp_role_assignment_ids" {
  value = azurerm_role_assignment.sp_roles[*].id
}

output "user_role_assignment_ids" {
  value = azurerm_role_assignment.user_roles[*].id
}

