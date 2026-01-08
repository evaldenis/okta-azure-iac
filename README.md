# Okta + Azure Infrastructure as Code

Complete Infrastructure as Code solution demonstrating OIDC authentication with Okta and Azure deployment using Terraform.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    User Authentication Flow                  │
└─────────────────────────────────────────────────────────────┘

    User                  Azure App              Okta IdP
     │                       │                      │
     │  1. Access App        │                      │
     ├──────────────────────>│                      │
     │                       │                      │
     │  2. Redirect to Login │                      │
     │<──────────────────────┤                      │
     │                       │                      │
     │  3. Authenticate      │                      │
     ├────────────────────────────────────────────>│
     │                       │                      │
     │  4. Auth Code         │                      │
     │<─────────────────────────────────────────────┤
     │                       │                      │
     │  5. Send Auth Code    │                      │
     ├──────────────────────>│                      │
     │                       │  6. Exchange Code    │
     │                       ├─────────────────────>│
     │                       │                      │
     │                       │  7. Access Token     │
     │                       │<─────────────────────┤
     │                       │                      │
     │  8. Show Profile      │                      │
     │<──────────────────────┤                      │
```

## Infrastructure Components

```
┌──────────────────────────────────────────────────────────┐
│                    Terraform Manages                      │
└──────────────────────────────────────────────────────────┘

  ┌─────────────────┐         ┌─────────────────┐
  │   Okta (IdP)    │         │  Azure (Cloud)  │
  ├─────────────────┤         ├─────────────────┤
  │ • OIDC App      │         │ • App Service   │
  │ • Test Users    │         │ • Service Plan  │
  │ • Assignments   │         │ • Configuration │
  │ • Auth Policies │         │ • Environment   │
  └─────────────────┘         └─────────────────┘
```

## Quick Start

### Prerequisites
- Terraform (or OpenTofu)
- Okta Developer Account
- Azure Subscription

### Setup

1. **Configure Terraform Variables**
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your credentials
```

2. **Deploy Infrastructure**
```bash
terraform init
terraform plan
terraform apply
```

3. **Test the Application**
- Open the output URL from Terraform
- Login with test user credentials
- View user profile

## Project Structure

```
.
├── terraform/              # Infrastructure as Code
│   ├── providers.tf       # Provider configurations
│   ├── variables.tf       # Input variables
│   ├── okta.tf           # Okta resources
│   ├── azure.tf          # Azure resources
│   └── outputs.tf        # Output values
├── app/                   # Node.js Application
│   ├── server.js         # OIDC implementation
│   ├── views/            # EJS templates
│   └── package.json      # Dependencies
└── .github/workflows/    # CI/CD Pipeline
    └── terraform.yml     # Automated validation & deployment
```

## Features

✅ Complete Infrastructure as Code with Terraform
✅ OIDC Authentication with Okta
✅ Azure App Service Deployment
✅ Automated User Provisioning
✅ CI/CD Pipeline with GitHub Actions
✅ User Profile Display

## Security

- Secrets managed via `terraform.tfvars` (not committed)
- Environment variables for sensitive data
- HTTPS-only communication
- OAuth 2.0 Authorization Code flow

## Technologies

- **IaC**: Terraform / OpenTofu
- **Identity Provider**: Okta
- **Cloud Platform**: Azure App Service
- **Application**: Node.js + Express
- **Auth Standard**: OpenID Connect (OIDC)
- **CI/CD**: GitHub Actions

---

Built with Infrastructure as Code principles for reproducible, version-controlled cloud deployments
