resource "azurerm_network_profile" "anp" {
  name                = "${var.env_name}-networkprofile"
  location            = var.group1_location
  resource_group_name = var.group1_name

  container_network_interface {
    name = "hellocnic"

    ip_configuration {
      name      = "helloipconfig"
      subnet_id = azurerm_subnet.subnet2.id
    }
  }
}

resource "azurerm_container_group" "acg" {
  name                = "${var.env_name}-container-group"
  location            = var.group1_location
  resource_group_name = var.group1_name
  ip_address_type     = "Private"
  network_profile_id  = azurerm_network_profile.anp.id
  os_type             = "Linux"
  restart_policy      = "Always"

  depends_on = [
    azurerm_storage_share.azfileshare
  ]

  image_registry_credential {
    server   = "azcontainerrepo.azurecr.io"
    username = "azcontainerrepo"
    password = "7mSA+5pAhXC0Pn4c5BvmtK6FEmsjxyi="
  }

  container {
    name   = "${var.env_name}-nginx-web"
    image  = "azcontainerrepo.azurecr.io/nginx:latest"
    cpu    = "0.5"
    memory = "1"

    ports {
      port     = 80
      protocol = "TCP"
    }

    volume {
      name                 = "data"
      mount_path           = "/usr/share/nginx/html"
      read_only            = false
      share_name           = element(var.import_fileshares, 0)
      storage_account_name = azurerm_storage_account.azstact.name
      storage_account_key  = azurerm_storage_account.azstact.primary_access_key
    }
  }

  container {
    name   = "${var.env_name}-filebrowser"
    image  = "hurlenko/filebrowser"
    cpu    = "0.3"
    memory = "0.5"
    environment_variables = {
      "FB_BASEURL" = "/filebrowser"
    }

    ports {
      port     = 8080
      protocol = "TCP"
    }

    volume {
      name                 = "data1"
      mount_path           = "/data"
      read_only            = false
      share_name           = element(var.import_fileshares, 0)
      storage_account_name = azurerm_storage_account.azstact.name
      storage_account_key  = azurerm_storage_account.azstact.primary_access_key
    }
  }

  tags = var.default_tag
}