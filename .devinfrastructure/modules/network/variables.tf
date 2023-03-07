variable "location" {
  type        = string
  description = "The Azure region for the resources (e.g. uksouth)"
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the network is located. This is different as we use a VPN or an agent in the network to deploy the solution and thus restrict public access."
}

variable "vnet_name" {
  type = string
}
variable "address_space" {
  type = string
}
variable "tags" {
}
locals {
  address_space = tolist([var.address_space])
  subnets  = cidrsubnets(local.address_space.0, 10, 10, 10, 10)
  vnet_name = var.vnet_name
  resource_group_name = var.resource_group_name
  location = var.location
  tags = var.tags
}