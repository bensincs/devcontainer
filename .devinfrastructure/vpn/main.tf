module "network" {
  source              = "../modules/network"
  location            = var.location
  resource_group_name = var.vpn_resource_group_name
  tags                = var.vpn_default_tags
  vnet_name           = var.vpn_vnet_name
  address_space       = var.vpn_address_space
}

module "vpn_gateway" {
  source                   = "../modules/vpn-gateway"
  location                 = var.location
  resource_group_name      = var.vpn_resource_group_name
  subnet_id                = module.network.gateway_subnet_id
  tags                     = var.vpn_default_tags
  gateway_public_ip_name   = var.vpn_gateway_public_ip_name
  vpn_client_address_space = ["10.20.2.0/29"]
  cert_organisation        = "az dev"

  depends_on = [module.network]
}

module "dns_resolver" {
  source              = "../modules/dns-forwarder"
  location            = var.location
  resource_group_name = var.vpn_resource_group_name
  tags                = var.vpn_default_tags
  subnet_id           = module.network.default_subnet_id
  cloudconfig_file    = "../modules/dns-forwarder/cloudinit.yml"
}
