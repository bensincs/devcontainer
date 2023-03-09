terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.46.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~>2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.1.0"
    }
  }
  required_version = ">= 0.13"
}
