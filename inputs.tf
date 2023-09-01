variable "subnet_names" {
  type    = list(string)
  default = ["app", "db"]

}

variable "subnet_ranges" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]

}

variable "database_info" {
  type = object({
    db_name        = string
    server_name    = string
    server_version = string
    user_name      = string
    password       = string
    max_size_gb    = number
    sku_name       = string

  })

}

variable "app_nsg_config" {
  type = object({
    name = string
    rules = list(object({
      name                       = string
      priority                   = string
      protocol                   = string
      direction                  = string
      access                     = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string

    }))
  })
}

variable "appvm_config" {
  type = object({
    subnet_name      = string
    size             = string
    username         = string
    keypath          = string
    publisher        = string
    offer            = string
    sku              = string
    version          = string
    private_key_path = string

  })
}
variable "vm_names" {
  type = list(string)
  default = ["app1","app2"]
}

variable "app_nic_names" {
  type = list(string)
  default = ["appnic1","appnic2"]
}

variable "app_script_version" {
  type = string
  default = "0"
}