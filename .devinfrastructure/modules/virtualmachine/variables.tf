variable "location" {
  type        = string
  description = "The Azure region for the resources (e.g. uksouth)"
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to place the Virtual Machine."
}
variable "vm_name" {
  type = string
}
variable "vm_user" {
  type    = string
  default = "az_user"
}
variable "vm_size" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "cloudconfig_content" {
  type = string
}
variable "create_public_ip" {
  type    = bool
  default = false
}
variable "useManagedIdentity" {
  type    = bool
  default = false
}
variable "userManagedIdentityResourceIds" {
  type    = list(string)
  default = [""]
}
variable "tags" {
}