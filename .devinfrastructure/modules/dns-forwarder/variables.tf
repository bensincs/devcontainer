variable "location" {
  type        = string
  description = "The Azure region for the resources (e.g. uksouth)"
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the DNS Resolver is created."
}
variable "subnet_id" {
  type = string
}

variable "vnet_id" {
  type = string
}