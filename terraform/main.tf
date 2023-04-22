terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
    features {}

    subscription_id = "6e3b70f0-3f80-4040-b014-efbab26b38a8"
    tenant_id = "3e443672-d53c-4e92-9a3f-057e4644ca9e"
}

resource "azurerm_resource_group" "IACAPP" {
  name = "IACAPP"
  location = "East US"
}

resource "azurerm_service_plan" "iaccomunidadecloudsp" {
  name = "iaccomunidadecloudsp"
  resource_group_name = azurerm_resource_group.IACAPP.name
  location = "East US"
  os_type = "Linux"
  sku_name = "F1"
}

resource "azurerm_linux_web_app" "iaccomunidadecloudweb" {
  resource_group_name = azurerm_resource_group.IACAPP.name
  name = "iaccomunidadecloudweb"
  location = azurerm_service_plan.iaccomunidadecloudsp.location
  service_plan_id = azurerm_service_plan.iaccomunidadecloudsp.id

  site_config {
    always_on = false
    ftps_state = "AllAllowed"
    container_registry_use_managed_identity = false
    application_stack {
      docker_image = "comunidadecloudiacacr.azurecr.io/myiacacr"
      docker_image_tag = "latest"
    }
  }
}