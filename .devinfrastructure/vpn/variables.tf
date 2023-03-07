variable "location" {
  type        = string
  description = "The Azure region for the resources (e.g. uksouth)"
}
variable "vpn_resource_group_name" {
  type        = string
  description = "The name of the resource group where the network is located. This is different as we use a VPN or an agent in the network to deploy the solution and thus restrict public access."
}
variable "vpn_vnet_name" {
  type = string
}
variable "vpn_gateway_public_ip_name" {
  type = string
}
variable "vpn_address_space" {
  type = string
}
variable "vpn_default_tags" {
  type    = map
  default = {}
}