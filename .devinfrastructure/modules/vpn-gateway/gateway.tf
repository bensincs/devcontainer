resource "azurerm_public_ip" "vpn_ip" {
  name                = local.gateway_public_ip_name
  location            = local.location
  resource_group_name = local.resource_group_name
  domain_name_label   = random_string.random.result
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = local.tags
  timeouts {
    read = "10m"
  }
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = "vpn_gateway"
  location            = local.location
  resource_group_name = local.resource_group_name
  tags                = local.tags
  type                = "Vpn"
  active_active       = false
  enable_bgp          = false
  sku                 = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = local.subnet_id
  }

  vpn_client_configuration {
    address_space        = local.vpn_client_address_space
    vpn_client_protocols = ["OpenVPN"]
    root_certificate {
      name             = "terraformselfsignedder"
      public_cert_data = data.local_file.ca_der.content
    }
  }

  depends_on = [azurerm_public_ip.vpn_ip]
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  number  = false
}
