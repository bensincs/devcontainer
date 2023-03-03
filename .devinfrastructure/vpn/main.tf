module "network" {
  source                      = "../modules/network"
  location                    = var.location
  network_resource_group_name = var.network_resource_group_name
  tags                        = var.defaultTags
  vnet_name                   = var.vnet_name
  front_end_address_space     = var.front_end_address_space
  back_end_address_space      = var.back_end_address_space
}

module "vpn_gateway" {
  source                      = "../modules/vpn-gateway"
  location                    = var.location
  network_resource_group_name = var.network_resource_group_name
  tags                        = var.defaultTags
  vnet_name                   = var.vnet_name
  gateway_public_ip_name      = var.gateway_public_ip_name
  front_end_address_space     = var.front_end_address_space
  vpn_client_address_space    = ["10.20.2.0/29"]
  cert_organisation           = "az dev"

  depends_on = [module.network]
}

module "dns_resolver" {
  source              = "../modules/dns-forwarder"
  location            = var.location
  resource_group_name = var.network_resource_group_name
  tags                = var.defaultTags
  subnet_id           = module.network.default_subnet_id
  cloudconfig_file    = "../modules/dns-forwarder/cloudinit.yml"
}