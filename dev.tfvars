database_info = {
   db_name        = "practdb"
    server_name    = "practserver"
    server_version = "12.0"
    user_name      = "india"
    password       = "mani@1923"
    max_size_gb    = 2
    sku_name       = "Basic"
}


app_nsg_config = {
  name = "app"
  rules = [{
    name                       = "open80"
    protocol                   = "Tcp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

    },
    {
      name                       = "open22"
      protocol                   = "Tcp"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"

    }
  ]
}

appvm_config = {
  subnet_name      = "app"
  size             = "Standard_B1s"
  username         = "azureuser"
  keypath          = "~/.ssh/id_rsa.pub"
  publisher        = "Canonical"
  offer            = "0001-com-ubuntu-server-focal"
  sku              = "20_04-lts"
  version          = "latest"
  private_key_path = "~/.ssh/id_rsa"

}

subnet_names  = ["app", "db"]
subnet_ranges = ["10.0.0.0/24", "10.0.1.0/24"]

vm_names = [ "app1","app2" ]  