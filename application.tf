
resource "azurerm_resource_group" "application" {
  name     = "rg-weu-${var.application}-${var.environment}"
  location = "West Europe"
}


resource "azurerm_network_interface" "appsrv" {
  name                = "appsrv-nic1"
  location            = azurerm_resource_group.application.location
  resource_group_name = azurerm_resource_group.application.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.services.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "appsrv" {
  name                  = "appsrv"
  resource_group_name   = azurerm_resource_group.application.name
  location              = azurerm_resource_group.application.location
  size                  = "Standard_D4as_v5"
  admin_username        = "adminuser"
  admin_password        = "P@$$w0rd1234!"
  patch_assessment_mode = "AutomaticByPlatform"

  network_interface_ids = [
    azurerm_network_interface.appsrv.id,
  ]

  os_disk {
    name                 = "appsrv-disk-os"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "256"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [
      identity,
    ]
  }
}
