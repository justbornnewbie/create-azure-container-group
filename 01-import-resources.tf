# import storage account and fileshare
resource "azurerm_storage_account" "azstact" {
  name                     = var.import_storage_account
  resource_group_name      = var.group1_name
  location                 = var.group1_location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_share" "azfileshare" {
  count                = length(var.import_fileshares)
  name                 = element(var.import_fileshares, count.index)
  quota                = 5120
  storage_account_name = azurerm_storage_account.azstact.name
  depends_on = [
    azurerm_storage_account.azstact
  ]
  lifecycle {
    prevent_destroy = true
  }
}

#import Resourcegroup
resource "azurerm_resource_group" "rg" {
  name     = var.group_name
  location = var.group_location
  tags     = var.group_tag
}

#import Resourcegroup
resource "azurerm_resource_group" "rg1" {
  name     = var.group1_name
  location = var.group1_location
  tags = {
    CostCenter = "PH2660"
  }
}

#import virtualnetwork. 
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.112.66.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.vnet_tag
}

#import subnets
resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = true 
  address_prefixes     = ["10.112.66.128/28"]

}

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  enforce_private_link_endpoint_network_policies = true
  address_prefixes     = ["10.112.66.144/28"]
  service_endpoints = [
    "Microsoft.ContainerRegistry",
    "Microsoft.Storage"
  ]
  delegation {
    name = "ACIDelegationService"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet" "subnet3" {
  name                                           = var.subnet3
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = ["10.112.66.0/26"]
  enforce_private_link_endpoint_network_policies = false
  #security_group                                 = dfci-ia-pods-dev-e2-nsg
   delegation {
    name = "databricks-del-private"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  } 
}

resource "azurerm_subnet" "subnet4" {
  name                                           = var.subnet4
  resource_group_name                            = azurerm_resource_group.rg.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = ["10.112.66.64/26"]
  enforce_private_link_endpoint_network_policies = false
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.EventHub",
    "Microsoft.KeyVault"
  ]
    delegation {
    name = "databricks-del-public"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}


