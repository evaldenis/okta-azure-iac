##############
# Okta Variables
##############

variable "okta_org_name" {
  description = "Okta organization name (e.g., dev-123456)"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL (usually okta.com or oktapreview.com)"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token for Terraform"
  type        = string
  sensitive   = true
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "okta-oidc-sample-app"
}

##############
# Azure Variables
##############

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
}

variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

##############
# Test Users
##############

variable "test_users" {
  description = "List of test users to create in Okta"
  type = list(object({
    first_name = string
    last_name  = string
    email      = string
    login      = string
  }))
  default = [
    {
      first_name = "Alice"
      last_name  = "Developer"
      email      = "alice.developer@example.com"
      login      = "alice.developer@example.com"
    },
    {
      first_name = "Bob"
      last_name  = "Tester"
      email      = "bob.tester@example.com"
      login      = "bob.tester@example.com"
    },
    {
      first_name = "Charlie"
      last_name  = "Admin"
      email      = "charlie.admin@example.com"
      login      = "charlie.admin@example.com"
    }
  ]
}
