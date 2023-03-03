resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "vm-${var.vm_name}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  tags                  = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = var.vm_name
  admin_username                  = var.vm_user
  disable_password_authentication = true
  custom_data                     = data.template_cloudinit_config.config.rendered

  admin_ssh_key {
    username   = var.vm_user
    public_key = tls_private_key.ssh.public_key_openssh
  }

  dynamic "identity" {
    for_each = var.useManagedIdentity ? [var.useManagedIdentity] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.userManagedIdentityResourceIds
    }
  }
}

resource "azurerm_network_interface" "nic" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = var.vm_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.vpn_ip[0].id : ""
  }
}

resource "azurerm_public_ip" "vpn_ip" {
  name                = "ip-${var.vm_name}-${random_string.random.result}"
  count               = var.create_public_ip ? 1 : 0
  location            = var.location
  tags                = var.tags
  resource_group_name = var.resource_group_name
  domain_name_label   = random_string.random.result
  allocation_method   = "Dynamic"
  timeouts {
    read = "10m"
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  number  = false
}
