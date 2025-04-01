# Assign roles to Service Principals
resource "azurerm_role_assignment" "sp_roles" {
  count                = length(var.sp_role_assignments)
  scope                = var.scope
  role_definition_name = var.sp_role_assignments[count.index].role
  principal_id         = var.sp_role_assignments[count.index].principal_id
}

# Assign roles to Users
resource "azurerm_role_assignment" "user_roles" {
  count                = length(var.user_role_assignments)
  scope                = var.scope
  role_definition_name = var.user_role_assignments[count.index].role
  principal_id         = var.user_role_assignments[count.index].principal_id
}

