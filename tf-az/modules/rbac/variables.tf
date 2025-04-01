variable "scope" {
  description = "The scope at which the role will be assigned"
  type        = string
}

variable "sp_role_assignments" {
  description = "List of role assignments for Service Principals"
  type = list(object({
    role         = string
    principal_id = string
  }))
  default = []
}

variable "user_role_assignments" {
  description = "List of role assignments for Users"
  type = list(object({
    role         = string
    principal_id = string
  }))
  default = []
}

