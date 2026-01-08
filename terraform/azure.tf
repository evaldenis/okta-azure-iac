##############
# Data Sources
##############

data "azurerm_resource_group" "main" {
  name = var.azure_resource_group
}

##############
# App Service Plan
##############

resource "azurerm_service_plan" "app" {
  name                = "${var.app_name}-plan-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1" # Basic tier - can change to F1 (Free) if available

  # Tags removed - Azure policy will inherit from Resource Group
  tags = {}
}

##############
# Linux Web App
##############

resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.app.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
    always_on = false # Set to false for Free/Basic tiers
  }

  app_settings = {
    # Okta Configuration - provided by Okta resources
    "OKTA_ISSUER"        = "https://${var.okta_org_name}.${var.okta_base_url}/oauth2/default"
    "OKTA_CLIENT_ID"     = okta_app_oauth.oidc_app.client_id
    "OKTA_CLIENT_SECRET" = okta_app_oauth.oidc_app.client_secret

    # Application Configuration
    "APP_BASE_URL"       = "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net"
    "REDIRECT_URI"       = "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net/authorization-code/callback"
    "PORT"               = "8080"
    "SESSION_SECRET"     = random_password.session_secret.result

    # Azure deployment settings
    "WEBSITE_NODE_DEFAULT_VERSION" = "18-lts"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
  }

  # Configure deployment from local Git or GitHub
  # This is a placeholder - in production, use CI/CD
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITES_ENABLE_APP_SERVICE_STORAGE"],
    ]
  }

  # Tags removed - Azure policy will inherit from Resource Group
  tags = {}
}

##############
# Generate Session Secret
##############

resource "random_password" "session_secret" {
  length  = 32
  special = true
}
