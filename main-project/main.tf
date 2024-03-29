terraform {
  backend "azurerm" {
    resource_group_name  = "NetworkWatcherRG"
    storage_account_name = "myfirsttrail"
    container_name       = "terraform-user-disable"
    key                  = "terraform.tfstate"
  }
  
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

module administrator {
  source = "../administrator/"
}



module user-disable {
  source = "../user-disable/"
  key_vault_name = module.administrator.key_vault_name
  key_vault_resource_group_name = module.administrator.key_vault_resource_group_name
  DOCKER_REGISTRY_SERVER_URL = var.DOCKER_REGISTRY_SERVER_URL
  DOCKER_REGISTRY_SERVER_USERNAME = var.DOCKER_REGISTRY_SERVER_USERNAME
  DOCKER_REGISTRY_SERVER_PASSWORD = var.DOCKER_REGISTRY_SERVER_PASSWORD

  depends_on = [
      module.administrator
  ]
}


