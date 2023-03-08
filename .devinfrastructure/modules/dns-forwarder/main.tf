resource "azurerm_private_dns_resolver" "resolver" {
  name                = "resolver"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_network_id  = var.vnet_id
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "endpoint" {
  name                    = "inbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.resolver.id
  location                = azurerm_private_dns_resolver.resolver.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.subnet_id
  }
}


output "dns_forwarder_ip" {
  value = azurerm_private_dns_resolver_inbound_endpoint.endpoint.ip_configurations[0].private_ip_address
}
