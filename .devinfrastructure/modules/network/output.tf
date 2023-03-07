output "default_subnet_id" {
  value = azurerm_subnet.default_subnet.id
}

output "gateway_subnet_id" {
  value = azurerm_subnet.gateway_subnet.id
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
}