resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "this" {
  name                = var.app_service_plan
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  os_type             = "Linux"
  sku_name            = var.sku_name   #
}


resource "azurerm_linux_web_app" "this" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  service_plan_id = azurerm_service_plan.this.id
  depends_on      = [azurerm_service_plan.this] 

  site_config {
    always_on                               = false
    application_stack {
      python_version = var.python_version
    }
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}

