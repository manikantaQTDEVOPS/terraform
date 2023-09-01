resource "azurerm_virtual_network" "practnet" {
  name                = "practnet"
  resource_group_name = azurerm_resource_group.practice.name
  location            = azurerm_resource_group.practice.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "appnsg" {
  name                = var.app_nsg_config.name
  location            = azurerm_resource_group.practice.location
  resource_group_name = azurerm_resource_group.practice.name

  depends_on = [azurerm_resource_group.practice]

}

resource "azurerm_network_security_rule" "appnsgrule" {
  count                       = length(var.app_nsg_config.rules)
  name                        = var.app_nsg_config.rules[count.index].name
  resource_group_name         = azurerm_resource_group.practice.name
  network_security_group_name = azurerm_network_security_group.appnsg.name
  protocol                    = var.app_nsg_config.rules[count.index].protocol
  priority                    = var.app_nsg_config.rules[count.index].priority
  direction                   = var.app_nsg_config.rules[count.index].direction
  access                      = var.app_nsg_config.rules[count.index].access
  source_port_range           = var.app_nsg_config.rules[count.index].source_port_range
  destination_port_range      = var.app_nsg_config.rules[count.index].destination_port_range
  source_address_prefix       = var.app_nsg_config.rules[count.index].source_address_prefix
  destination_address_prefix  = var.app_nsg_config.rules[count.index].destination_address_prefix

  depends_on = [azurerm_network_security_group.appnsg]
}


data "azurerm_subnet" "app" {
  name                 = var.appvm_config.subnet_name
  virtual_network_name = azurerm_virtual_network.practnet.name
  resource_group_name  = azurerm_resource_group.practice.name


  depends_on = [azurerm_subnet.practsubnets]


}

resource "azurerm_network_interface" "app" {
  count               = length(var.app_nic_names)
  name                = var.app_nic_names[count.index]
  location            = azurerm_resource_group.practice.location
  resource_group_name = azurerm_resource_group.practice.name
  ip_configuration {
    name                          = "appipconfig-${count.index}"
    subnet_id                     = data.azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [azurerm_public_ip.app, azurerm_network_security_group.appnsg]
}

resource "azurerm_network_interface_security_group_association" "appnsg" {
  count = length(azurerm_network_interface.app)
  network_interface_id      = azurerm_network_interface.app[count.index].id
  network_security_group_id = azurerm_network_security_group.appnsg.id

  depends_on = [azurerm_network_interface.app, azurerm_network_security_group.appnsg]

}