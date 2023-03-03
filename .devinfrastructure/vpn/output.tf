output "client_cert" {
  value     = module.vpn_gateway.client_cert
  sensitive = true
}

output "client_key" {
  value     = module.vpn_gateway.client_key
  sensitive = true
}

output "vpn_id" {
  value = module.vpn_gateway.vpn_id
}

output "vpn_ip" { # use this for /etc/hosts entry for VPN Gateway
  value = module.vpn_gateway.vpn_ip
}

output "dns_forwarder_ip" { # use this for resolv.conf for DNS
  value = module.dns_resolver.dns_forwarder_ip
}