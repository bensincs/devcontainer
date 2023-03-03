module "dns_forwarder" {
  source              = "../virtualmachine"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  vm_name             = "dns-forwarder"
  vm_size             = "Standard_B1s"
  subnet_id           = var.subnet_id
  cloudconfig_content = templatefile(var.cloudconfig_file, {})
}

resource "local_file" "ssh_key" {
  filename = ".sshDNSKey"
  content  = module.dns_forwarder.tls_private_key
}

output "dns_forwarder_ip" {
  value = module.dns_forwarder.vm_ip
}
