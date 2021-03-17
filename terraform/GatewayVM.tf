#######################################################################
## Create Public IP
#######################################################################

resource "azurerm_public_ip" "gw-pip" {
  name                = "${var.prefix}-gw-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = var.tags
}

#######################################################################
## Create Network Interface
#######################################################################

resource "azurerm_network_interface" "gw-nic" {
  name                = "${var.prefix}-gw-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.prefix}-gw-nic-cfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.gw-pip.id
  }
}

#######################################################################
## Create Gateway Virtual Machine
#######################################################################

resource "azurerm_virtual_machine" "gw-vm" {
  name                  = "${var.prefix}-gw-vm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [ azurerm_network_interface.gw-nic.id ]
  vm_size               = var.vmsize

  storage_os_disk {
    name              = "${var.prefix}-gw-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }

  os_profile {
    computer_name   = "${var.prefix}-gw-vm"
    admin_username  = var.username
    admin_password  = var.password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

#######################################################################
## Show Gateway IP
#######################################################################

data "azurerm_public_ip" "gw-ip" {
  name                  = azurerm_public_ip.gw-pip.name
  resource_group_name   = azurerm_virtual_machine.gw-vm.resource_group_name
  depends_on            = [azurerm_virtual_machine.gw-vm]
}

output "public_ip_address" {
  value = data.azurerm_public_ip.gw-ip.ip_address
}