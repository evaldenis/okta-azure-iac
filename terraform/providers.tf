terraform {
  required_version = ">= 1.0"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "evaldas_tryout"
    storage_account_name = "oktaiacstate"
    container_name       = "tfstate"
    key                  = "okta-oidc-app.tfstate"
  }
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_api_token
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}
