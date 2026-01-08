##############
# Okta OIDC Application
##############

resource "okta_app_oauth" "oidc_app" {
  label                      = var.app_name
  type                       = "web"
  grant_types                = ["authorization_code"]
  redirect_uris              = [
    "http://localhost:3000/authorization-code/callback",
    "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net/authorization-code/callback"
  ]
  post_logout_redirect_uris  = [
    "http://localhost:3000",
    "https://${var.app_name}-${var.environment}-${substr(md5(data.azurerm_resource_group.main.id), 0, 6)}.azurewebsites.net"
  ]
  response_types             = ["code"]
  consent_method             = "TRUSTED"
  issuer_mode                = "ORG_URL"
}

# Scopes are automatically available for OIDC apps
# Explicit API scope grant removed due to compatibility issues

##############
# Test Users
##############

resource "okta_user" "test_users" {
  count      = length(var.test_users)
  first_name = var.test_users[count.index].first_name
  last_name  = var.test_users[count.index].last_name
  login      = var.test_users[count.index].login
  email      = var.test_users[count.index].email
  status     = "ACTIVE"

  # Set a temporary password - users should change on first login
  password = "TempPass123!"

  lifecycle {
    ignore_changes = [password]
  }
}

##############
# Assign Users to Application (Direct Assignment - More Reliable)
##############

resource "okta_app_user" "test_user_assignments" {
  count    = length(okta_user.test_users)
  app_id   = okta_app_oauth.oidc_app.id
  user_id  = okta_user.test_users[count.index].id
  username = okta_user.test_users[count.index].login
}

##############
# Optional: Groups & Policies (if needed)
##############

# Uncomment if you want to use groups for other purposes
# resource "okta_group" "test_users_group" {
#   name        = "Terraform Test Users"
#   description = "Group for test users created by Terraform"
# }
#
# resource "okta_group_memberships" "test_users" {
#   group_id = okta_group.test_users_group.id
#   users    = okta_user.test_users[*].id
# }