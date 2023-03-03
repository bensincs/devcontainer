output "client_cert" {
  value     = tls_locally_signed_cert.client_cert.cert_pem
  sensitive = true
}

output "client_key" {
  value     = tls_private_key.client_cert.private_key_pem
  sensitive = true
}

output "vpn_id" {
  value = azurerm_virtual_network_gateway.vpn_gateway.id
}

output "vpn_ip" { # use this for /etc/hosts entry for VPN Gateway
  value = azurerm_public_ip.vpn_ip.ip_address
}
