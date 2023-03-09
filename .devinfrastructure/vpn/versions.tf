terraform {
  backend "azurerm" {

  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.46.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~>3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~>2.2.0"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}
