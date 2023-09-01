resource "azurerm_linux_virtual_machine" "app" {
  count               = length(var.vm_names)
  name                = var.vm_names[count.index]
  resource_group_name = azurerm_resource_group.practice.name
  location            = azurerm_resource_group.practice.location
  size                = var.appvm_config.size
  admin_username      = var.appvm_config.username
  admin_ssh_key {
    username   = var.appvm_config.username
    public_key = file(var.appvm_config.keypath)
  }

  network_interface_ids = [azurerm_network_interface.app[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.appvm_config.publisher
    offer     = var.appvm_config.offer
    sku       = var.appvm_config.sku
    version   = var.appvm_config.version
  }
}

resource "null_resource" "script_executor" {

  provisioner "remote-exec" {
     connection {
        type = "ssh"
        user = var.appvm_config.username
        private_key = file(var.appvm_config.private_key_path)
        host = azurerm_linux_virtual_machine.app[0].private_ip_address
      }
    inline = [ 
       "sudo apt update",
       "sudo apt install openjdk-17-jdk -y",
       "wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb",
        "sudo dpkg -i packages-microsoft-prod.deb",
       "rm packages-microsoft-prod.deb",
       "sudo apt install dotnet-sdk-7.0",
       "cd /tmp",
       "git clone https://github.com/manikantaQTDEVOPS/nopCommerce-july23.git",
       "cd nopCommerce-july23",
       "dotnet restore src/NopCommerce.sln",
       "dotnet build -c Release src/NopCommerce.sln"
     ]
     
  }

  triggers = {
    app_script_version = var.app_script_version
  }

   depends_on = [azurerm_linux_virtual_machine.app ] 
}