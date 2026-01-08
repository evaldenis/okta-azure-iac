##############
# Okta Outputs
##############

output "okta_app_id" {
  description = "Okta Application ID"
  value       = okta_app_oauth.oidc_app.id
}

output "okta_client_id" {
  description = "Okta Client ID"
  value       = okta_app_oauth.oidc_app.client_id
}

output "okta_client_secret" {
  description = "Okta Client Secret"
  value       = okta_app_oauth.oidc_app.client_secret
  sensitive   = true
}

output "okta_issuer" {
  description = "Okta Issuer URL"
  value       = "https://${var.okta_org_name}.${var.okta_base_url}/oauth2/default"
}

output "test_users" {
  description = "Created test users"
  value = [
    for user in okta_user.test_users : {
      name  = "${user.first_name} ${user.last_name}"
      email = user.email
      login = user.login
    }
  ]
}

##############
# Azure Outputs
##############

output "app_service_url" {
  description = "URL of the deployed application"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "app_service_name" {
  description = "Name of the Azure App Service"
  value       = azurerm_linux_web_app.app.name
}

output "resource_group" {
  description = "Azure Resource Group"
  value       = data.azurerm_resource_group.main.name
}

##############
# Summary
##############

output "deployment_summary" {
  description = "Quick reference for the deployment"
  value = {
    app_url           = "https://${azurerm_linux_web_app.app.default_hostname}"
    okta_org          = "https://${var.okta_org_name}.${var.okta_base_url}"
    test_user_count   = length(okta_user.test_users)
    default_password  = "TempPass123! (change on first login)"
  }
}
