variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "app_name" {
  description = "The name of the application registration"
  type        = string
}

variable "location" {
  type        = string
  description = "Azure region where the VNet will be created"
}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
