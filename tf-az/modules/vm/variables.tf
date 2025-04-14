variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "public_ip" { default = false }
variable "username" {}
variable "password" {}
variable "public_ip_id" {
  description = "The public IP ID for the public VM"
  type        = string
  default     = ""  # Default can be an empty string since it may be optional for private VMs
}
