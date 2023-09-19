
resource "azurerm_resource_group" "network" {
  name     = "rg-weu-${var.application}-network"
  location = "West Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "vnet-lz-${var.application}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

}

resource "azurerm_subnet" "services" {
  name                 = "services"
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.2.0/24"]
}
