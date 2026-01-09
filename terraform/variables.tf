variable "okta_org_name" {
  description = "Okta organization name"
  type        = string
}

variable "okta_base_url" {
  description = "Okta base URL"
  type        = string
  default     = "okta.com"
}

variable "okta_api_token" {
  description = "Okta API token"
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_resource_group" {
  description = "Azure resource group name"
  type        = string
}

variable "os_type" {
  description = "Operating system type"
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "Azure App Service Plan SKU"
  type        = string
  default     = "B1"
}

variable "node_version" {
  description = "Node.js version"
  type        = string
  default     = "18-lts"
}

variable "always_on" {
  description = "Keep app always on"
  type        = bool
  default     = false
}

variable "auth_server_path" {
  description = "Authorization server path"
  type        = string
  default     = "oauth2/default"
}

variable "app_port" {
  description = "Application port"
  type        = string
  default     = "8080"
}

variable "node_env" {
  description = "Node environment"
  type        = string
  default     = "production"
}

variable "scm_build_enabled" {
  description = "Enable SCM build during deployment"
  type        = string
  default     = "true"
}

variable "session_secret_length" {
  description = "Session secret length"
  type        = number
  default     = 32
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "okta-oidc-sample-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "app_type" {
  description = "Okta application type"
  type        = string
  default     = "web"
}

variable "grant_types" {
  description = "OAuth grant types"
  type        = list(string)
  default     = ["authorization_code"]
}

variable "response_types" {
  description = "OAuth response types"
  type        = list(string)
  default     = ["code"]
}

variable "consent_method" {
  description = "Application consent method"
  type        = string
  default     = "TRUSTED"
}

variable "issuer_mode" {
  description = "Okta issuer mode"
  type        = string
  default     = "ORG_URL"
}

variable "local_app_url" {
  description = "Local application URL"
  type        = string
  default     = "http://localhost:3000"
}

variable "callback_path" {
  description = "OAuth callback path"
  type        = string
  default     = "/authorization-code/callback"
}

variable "scopes" {
  description = "OAuth scopes"
  type        = list(string)
  default     = ["openid", "profile", "email"]
}

variable "auth_server_name" {
  description = "Authorization server name"
  type        = string
  default     = "default"
}

variable "policy_name" {
  description = "Auth server policy name"
  type        = string
  default     = "Application Policy"
}

variable "policy_description" {
  description = "Auth server policy description"
  type        = string
  default     = "Policy for OIDC application access"
}

variable "policy_status" {
  description = "Policy status"
  type        = string
  default     = "ACTIVE"
}

variable "policy_priority" {
  description = "Policy priority"
  type        = number
  default     = 1
}

variable "policy_rule_name" {
  description = "Auth server policy rule name"
  type        = string
  default     = "Allow Authorization Code Flow"
}

variable "policy_rule_status" {
  description = "Policy rule status"
  type        = string
  default     = "ACTIVE"
}

variable "policy_rule_priority" {
  description = "Policy rule priority"
  type        = number
  default     = 1
}

variable "everyone_group_id" {
  description = "Okta Everyone group ID"
  type        = string
  default     = "00gyzon724obLjzHR697"
}

variable "signon_policy_name" {
  description = "Sign-on policy name"
  type        = string
  default     = "Password Only Policy"
}

variable "signon_policy_description" {
  description = "Sign-on policy description"
  type        = string
  default     = "Password-only authentication policy"
}

variable "signon_rule_name" {
  description = "Sign-on rule name"
  type        = string
  default     = "Password Only Rule"
}

variable "mfa_required" {
  description = "Require MFA"
  type        = bool
  default     = false
}

variable "policy_access" {
  description = "Policy access setting"
  type        = string
  default     = "ALLOW"
}

variable "user_status" {
  description = "Default user status"
  type        = string
  default     = "ACTIVE"
}

variable "default_user_password" {
  description = "Default password for test users"
  type        = string
  default     = "TempPass123!"
  sensitive   = true
}

variable "test_users" {
  description = "Test users list"
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
# CI/CD test
