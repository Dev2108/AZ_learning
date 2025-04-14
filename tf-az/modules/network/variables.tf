variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "address_space" {
  type        = list(string)
  description = "Address space for the Virtual Network"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "subnets" {
  type = map(string)
  description = "Subnets map with subnet name as key and address prefix as value"
}

variable "public_ip_address" {
  description = "The public IP address to allow SSH from"
  type        = string
}

