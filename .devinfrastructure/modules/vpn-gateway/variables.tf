variable "location" {
  type        = string
}
variable "resource_group_name" {
  type        = string
}
variable "subnet_id" {
  type = string
}
variable "gateway_public_ip_name" {
  type = string
}
variable "vpn_client_address_space" {
  type = list(string)
}
variable "cert_organisation" {
  type = string
}
variable "tags" {
}

locals {
  location = var.location
  resource_group_name = var.resource_group_name
  subnet_id = var.subnet_id
  gateway_public_ip_name = var.gateway_public_ip_name
  vpn_client_address_space = var.vpn_client_address_space
  cert_organisation = var.cert_organisation
  tags = var.tags
}
