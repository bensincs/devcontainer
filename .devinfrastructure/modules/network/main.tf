resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "network" {
  name                = local.vnet_name
  location            = local.location
  resource_group_name = azurerm_resource_group.network.name
  tags                = azurerm_resource_group.network.tags
  address_space       = local.address_space
}

resource "azurerm_subnet" "default_subnet" {
  name                                           = "default"
  virtual_network_name                           = azurerm_virtual_network.network.name
  resource_group_name                            = azurerm_resource_group.rg.name
  address_prefixes                               = [local.subnets.1]
  service_endpoints                              = ["Microsoft.ContainerRegistry", "Microsoft.AzureActiveDirectory", "Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.EventHub", "Microsoft.ServiceBus", "Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_network_security_group" "denyRDP" {
  name                = "denyRDP"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = azurerm_resource_group.rg.tags
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
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "local" {
  name                  = "dev.local"
  resource_group_name   = azurerm_resource_group.rf.name
  private_dns_zone_name = azurerm_private_dns_zone.local.name
  virtual_network_id    = azurerm_virtual_network.network.id
  registration_enabled  = true
}
