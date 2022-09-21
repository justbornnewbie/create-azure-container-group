# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.8.0"
    }
  }

/*   backend "azurerm" {
    resource_group_name  = "dfci-ia-network-poc-e2-1-rg"
    storage_account_name = "vsl8terraform"
    container_name       = "prodtfstate"
    key                  = "pr1-nginx-with-firebrower.tfstate"
  } */
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
