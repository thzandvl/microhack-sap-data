#######################################################################
## Create Storage Account
#######################################################################

resource "random_id" "id" {
  byte_length = 8
}

resource "azurerm_storage_account" "storage" {
    name                        = "sapdata${lower(random_id.id.hex)}"
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = azurerm_resource_group.rg.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"
    account_kind                = "StorageV2"
    is_hns_enabled              = "true"
    tags                        = var.tags
}

#######################################################################
## Create ADLS filesystem
#######################################################################

resource "azurerm_storage_data_lake_gen2_filesystem" "adls" {
  depends_on            = [time_sleep.wait_10_seconds]
  name                  = "${var.prefix}-adls"
  storage_account_id    = azurerm_storage_account.storage.id
}

#######################################################################
## Create ADLS path
#######################################################################

resource "azurerm_storage_data_lake_gen2_path" "staging" {
  path                  = "staging"
  filesystem_name       = azurerm_storage_data_lake_gen2_filesystem.adls.name
  storage_account_id    = azurerm_storage_account.storage.id
  resource              = "directory"
}

#######################################################################
## Create Synapse Workspace
#######################################################################

resource "azurerm_synapse_workspace" "synapse" {
    name                                    = "sapdatasynws${lower(random_id.id.hex)}"
    resource_group_name                     = azurerm_resource_group.rg.name
    location                                = azurerm_resource_group.rg.location
    storage_data_lake_gen2_filesystem_id    = azurerm_storage_data_lake_gen2_filesystem.adls.id
    sql_administrator_login                 = var.username
    sql_administrator_login_password        = var.password
    tags                                    = var.tags
}

#######################################################################
## Create Synapse SQL Pool
#######################################################################

resource "azurerm_synapse_sql_pool" "sqlpool" {
  name                  = "sapdatasynsql"
  synapse_workspace_id  = azurerm_synapse_workspace.synapse.id
  sku_name              = "DW100c"
  create_mode           = "Default"
}