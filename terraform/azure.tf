data "azurerm_resource_group" "main" {
  name = var.azure_resource_group
}

resource "azurerm_service_plan" "app" {
  name                = "${var.app_name}-plan-${var.environment}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = {}
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.app.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      node_version = var.node_version
    }
    always_on       = var.always_on
    http2_enabled   = true
    ftps_state      = "Disabled"
    min_tls_version = "1.2"
  }

  app_settings = {
    "OKTA_ISSUER"                    = "https://${var.okta_org_name}.${var.okta_base_url}/${var.auth_server_path}"
    "OKTA_CLIENT_ID"                 = okta_app_oauth.oidc_app.client_id
    "OKTA_CLIENT_SECRET"             = okta_app_oauth.oidc_app.client_secret
    "APP_BASE_URL"                   = "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net"
    "REDIRECT_URI"                   = "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net${var.callback_path}"
    "PORT"                           = var.app_port
    "SESSION_SECRET"                 = random_password.session_secret.result
    "NODE_ENV"                       = var.node_env
    "WEBSITE_NODE_DEFAULT_VERSION"   = var.node_version
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = var.scm_build_enabled
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITES_ENABLE_APP_SERVICE_STORAGE"],
    ]
  }

  tags = {}
}

resource "random_password" "session_secret" {
  length  = var.session_secret_length
  special = true
}
