#######################
## NETWORK INTERFACE ##
#######################

resource "azurerm_network_interface" "vm" {
  count = length(var.instances)

  name                = "nic-wordpress-${var.instances[count.index]}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.pip_ids # retrieves a single element from a list: element(list, index)
  }
}

resource "azurerm_network_interface_application_security_group_association" "vm" {
  for_each = azurerm_network_interface.vm

  network_interface_id          = each.value.id
  application_security_group_id = var.asg_id
}

#####################
## VIRTUAL MACHINE ##
#####################

resource "azurerm_linux_virtual_machine" "vm" {
  for_each = azurerm_network_interface.vm

  name                            = "vm-wordpress-${each.key}"
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  size                            = "Standard_B2s"
  admin_username                  = var.db_user
  admin_password                  = var.db_pw
  disable_password_authentication = false
  network_interface_ids = [
    each.value.id, 
  ] ##

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  provisioner "file" {
    content = templatefile("2-start-wordpress.tpl", {
      db_user     = var.db_user
      db_pass     = var.db_pw
      db_url      = var.db_url
      db_name_key = each.key
    })
    destination = "/tmp/setup.sh"

    connection {
      host     = self.public_ip_address
      user     = self.admin_username
      password = self.admin_password
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh",
    ]

    connection {
      host     = self.public_ip_address
      user     = self.admin_username
      password = self.admin_password
      agent    = false
    }
  }
}
