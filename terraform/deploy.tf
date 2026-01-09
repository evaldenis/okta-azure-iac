resource "terraform_data" "app_deployment" {
  # Trigger redeployment when any file in the app directory changes
  triggers_replace = [
    sha256(join("", [for f in fileset("${path.module}/../app", "**") : filesha256("${path.module}/../app/${f}")]))
  ]

  depends_on = [azurerm_linux_web_app.app]

  provisioner "local-exec" {
    working_dir = "${path.module}/../app"
    command     = <<EOT
      # Create deployment zip
      zip -r ../app.zip . -x "node_modules/*" -x ".DS_Store"
      
      # Deploy using Azure CLI
      # We use the app name and resource group from the terraform resources
      az webapp deployment source config-zip \
        --resource-group ${data.azurerm_resource_group.main.name} \
        --name ${azurerm_linux_web_app.app.name} \
        --src ../app.zip \
        --timeout 600
    EOT
  }
}
