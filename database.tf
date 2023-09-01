resource "azurerm_mssql_server" "practserver" {
  name                          = var.database_info.server_name
  resource_group_name           = azurerm_resource_group.practice.name
  location                      = azurerm_resource_group.practice.location
  version                       = var.database_info.server_version
  administrator_login           = var.database_info.user_name
  administrator_login_password  = var.database_info.password
  public_network_access_enabled = true

}

resource "azurerm_mssql_database" "practdb" {
  name        = var.database_info.db_name
  server_id   = azurerm_mssql_server.practserver.id
  max_size_gb = var.database_info.max_size_gb
  sku_name    = var.database_info.sku_name

}