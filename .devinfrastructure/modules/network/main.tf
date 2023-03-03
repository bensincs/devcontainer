resource "azurerm_resource_group" "developer_network" {
  name     = var.network_resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vpn_net" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.developer_network.name
  tags                = azurerm_resource_group.developer_network.tags
  address_space       = local.vnet_address_space
}

resource "azurerm_subnet" "default_subnet" {
  name                                           = "default"
  virtual_network_name                           = azurerm_virtual_network.vpn_net.name
  resource_group_name                            = azurerm_resource_group.developer_network.name
  address_prefixes                               = [local.front_end_subnets.1]
  service_endpoints                              = ["Microsoft.ContainerRegistry", "Microsoft.AzureActiveDirectory", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.EventHub", "Microsoft.ServiceBus", "Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_network_security_group" "denyRDP" {
  name                = "denyRDP"
  location            = var.location
  resource_group_name = azurerm_resource_group.developer_network.name
  tags                = azurerm_resource_group.developer_network.tags
  security_rule {
    name                       = "denyRDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "denyRDP" {
  subnet_id                 = azurerm_subnet.default_subnet.id
  network_security_group_id = azurerm_network_security_group.denyRDP.id
}

resource "azurerm_private_dns_zone" "local" {
  name                = "dev.local"
  resource_group_name = azurerm_resource_group.developer_network.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "local" {
  name                  = "dev.local"
  resource_group_name   = azurerm_resource_group.developer_network.name
  private_dns_zone_name = azurerm_private_dns_zone.local.name
  virtual_network_id    = azurerm_virtual_network.vpn_net.id
  registration_enabled  = true
}
