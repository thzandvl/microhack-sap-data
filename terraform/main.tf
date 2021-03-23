terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "id" {
  byte_length = 8
}

#######################################################################
## Create Resource Group
#######################################################################

resource "azurerm_resource_group" "rg" {
  name     = "microhack-${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

#######################################################################
## Assign Storage Role to User
#######################################################################

data "azurerm_client_config" "user" {
}

locals {
  object_id = data.azurerm_client_config.user.object_id == "" ? var.object_id : data.azurerm_client_config.user.object_id
}

resource "azurerm_role_assignment" "storagerole" {
  scope                 = azurerm_resource_group.rg.id
  role_definition_name  = "Storage Blob Data Owner"
  principal_id          = local.object_id
}

resource "time_sleep" "wait_10_seconds" {
    depends_on = [azurerm_role_assignment.storagerole]
    create_duration = "10s"
}

#######################################################################
## Create Virtual Networks
#######################################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.address_space
  tags                = var.tags
}

#######################################################################
## Create Subnet
#######################################################################

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}

#######################################################################
## Create Network Security Group
#######################################################################

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags

  security_rule {
    name                        = "RDP"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

#######################################################################
## Associate the subnet with the NSG
#######################################################################

resource "azurerm_subnet_network_security_group_association" "nsg-ass" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}