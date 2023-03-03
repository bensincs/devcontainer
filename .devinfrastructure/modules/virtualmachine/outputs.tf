output "vm_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "tls_private_key" {
  value = tls_private_key.ssh.private_key_pem
}

output "azurerm_virtual_machine_id" {
  value = azurerm_linux_virtual_machine.vm.id
}