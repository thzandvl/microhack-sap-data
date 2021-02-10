# SAP Microhack: CashFlow Prediction
For this Microhack we will:
* Extract (Historical) Sales Orders from SAP S/4HANA and load this in Synapse
* Upload historical payments from a non-SAP system, in this example Cosmos DB, to Synapse
* Visualize the extracted Sales Orders and invoice data with Power BI
* Predict incoming cash flow for new Sales Orders

## Scenario Description


## Get Started
To start with the Microhack we first need to take some preparation steps:

0. [Software Prerequisites](SoftwarePrerequisites.md)
1. [Deploy a gateway server for the SAP RFC connection](DeployGatewayVM.md)
2. [Prepare the Gateway server](PrepareGateway.md)
3. [Create Synapse Workspace](SynapseWorkspace.md)

ToDo
- [ ] Scenario Description
- [ ] Create Datalake for staging
- [ ] Create Datafactory
- [ ] Create Synapse (Workspace?)
- [ ] CosmosDB Connection This probably only works when participants have access to the subscription
- [ ] Gateway installation vs ADF Runtime integration
