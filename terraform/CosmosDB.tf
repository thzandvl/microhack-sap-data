#Create CosmosDB Account
resource "azurerm_cosmosdb_account" "acc" {
  name                = "${var.prefix}-cosmos"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  tags                = var.tags

  enable_automatic_failover = false
  consistency_policy {
    consistency_level       = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

#Create SQL Database
resource "azurerm_cosmosdb_sql_database" "db" {
  name                = "SAPS4D"
  resource_group_name = azurerm_cosmosdb_account.acc.resource_group_name
  account_name        = azurerm_cosmosdb_account.acc.name
}

#Create Collection
resource "azurerm_cosmosdb_sql_container" "paymentData" {
  name                  = "paymentData"
  resource_group_name   = azurerm_cosmosdb_account.acc.resource_group_name
  account_name          = azurerm_cosmosdb_account.acc.name
  database_name         = azurerm_cosmosdb_sql_database.db.name
  partition_key_path    = "/CustomerNr"
  partition_key_version = 1
  throughput            = 400
}