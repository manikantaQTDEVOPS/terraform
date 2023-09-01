resource "azurerm_subnet" "practsubnets" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.practice.name
  virtual_network_name = azurerm_virtual_network.practnet.name
  address_prefixes     = [var.subnet_ranges[count.index]]

}