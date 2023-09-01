resource "azurerm_public_ip" "app" {
  name                = "apppubip"
  resource_group_name = azurerm_resource_group.practice.name
  location            = azurerm_resource_group.practice.location
  allocation_method   = "Static"
  sku = "Basic"

}

resource "azurerm_lb" "app_lb" {
  name                = "app-lb"
  location            = azurerm_resource_group.practice.location
  resource_group_name = azurerm_resource_group.practice.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.app.id
  }
}

resource "azurerm_lb_probe" "probe" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name = "app-probe"
  port = "80"
  protocol = "Http"
  request_path = "/"
  
}

resource "azurerm_lb_rule" "app-lbrule" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name = "applb_rule"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id = azurerm_lb_probe.probe.id
#   backend_address_pool_ids = azurerm_lb_backend_address_pool.app_backend_pool[0].id 
}

resource "azurerm_lb_backend_address_pool" "app_backend_pool" {
  loadbalancer_id     = azurerm_lb.app_lb.id
  name                = "app-backend-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_association" {
  network_interface_id    = azurerm_network_interface.app[0].id
  ip_configuration_name   = azurerm_network_interface.app[0].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_backend_pool.id
}

# resource "azurerm_network_interface_backend_address_pool_association" "lb_association1" {
#   network_interface_id = azurerm_network_interface.app[1].id
#   ip_configuration_name   = azurerm_network_interface.app[1].ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.app_backend_pool.id
  
  
# }