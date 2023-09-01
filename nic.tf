resource "azurerm_public_ip" "app1_public_ip" {
  name                = "app1-pip"
  resource_group_name = azurerm_resource_group.practice.name
  location            = azurerm_resource_group.practice.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "app1_lb" {
  name                = "app1-lb"
  resource_group_name = "practice"
  location            = "East US"
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "FrontendIP"
    public_ip_address_id = azurerm_public_ip.app1_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "app1_backend_pool" {
  name                = "app1-backend-pool"
#   resource_group_name = "practice"
  loadbalancer_id     = azurerm_lb.app1_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "app1_lb_association" {
  network_interface_id    = azurerm_network_interface.app[1].id
  ip_configuration_name   = azurerm_network_interface.app[1].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.app1_backend_pool.id
}
