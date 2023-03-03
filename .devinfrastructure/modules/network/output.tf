output "default_subnet_id" {
  value = azurerm_subnet.default_subnet.id
}

output "resource_group_name" {
  value       = azurerm_resource_group.developer_network.name
  description = "Used so that we can take a dependency on the creation of the resource group"
}