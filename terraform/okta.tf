data "okta_auth_server" "default" {
  name = var.auth_server_name
}

resource "okta_app_oauth" "oidc_app" {
  label       = var.app_name
  type        = var.app_type
  grant_types = var.grant_types
  redirect_uris = [
    "${var.local_app_url}${var.callback_path}",
    "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net${var.callback_path}"
  ]
  post_logout_redirect_uris = [
    var.local_app_url,
    "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net"
  ]
  response_types = var.response_types
  consent_method = var.consent_method
  issuer_mode    = var.issuer_mode
}

resource "okta_auth_server_policy" "app_policy" {
  auth_server_id   = data.okta_auth_server.default.id
  status           = var.policy_status
  name             = var.policy_name
  description      = var.policy_description
  priority         = var.policy_priority
  client_whitelist = [okta_app_oauth.oidc_app.id]
}

resource "okta_auth_server_policy_rule" "app_policy_rule" {
  auth_server_id       = data.okta_auth_server.default.id
  policy_id            = okta_auth_server_policy.app_policy.id
  status               = var.policy_rule_status
  name                 = var.policy_rule_name
  priority             = var.policy_rule_priority
  grant_type_whitelist = var.grant_types
  scope_whitelist      = var.scopes

  group_whitelist = [var.everyone_group_id]
}

resource "okta_user" "test_users" {
  count      = length(var.test_users)
  first_name = var.test_users[count.index].first_name
  last_name  = var.test_users[count.index].last_name
  login      = var.test_users[count.index].login
  email      = var.test_users[count.index].email
  status     = var.user_status
  password   = var.default_user_password

  lifecycle {
    ignore_changes = [password]
  }
}

resource "okta_app_user" "test_user_assignments" {
  count    = length(okta_user.test_users)
  app_id   = okta_app_oauth.oidc_app.id
  user_id  = okta_user.test_users[count.index].id
  username = okta_user.test_users[count.index].login
}

resource "okta_policy_signon" "password_only" {
  name            = var.signon_policy_name
  status          = var.policy_status
  description     = var.signon_policy_description
  priority        = var.policy_priority
  groups_included = [var.everyone_group_id]
}

resource "okta_policy_rule_signon" "password_only_rule" {
  policy_id    = okta_policy_signon.password_only.id
  name         = var.signon_rule_name
  status       = var.policy_rule_status
  priority     = var.policy_rule_priority
  mfa_required = var.mfa_required
  access       = var.policy_access
}