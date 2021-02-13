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
3. [Synapse Workspace Setup](SynapseWorkspace.md)
4. [PowerBI Visualisation](PowerBiVisualisation.md)

ToDo
- [ ] Scenario Description
- [x] Create Synapse Workspace
- [ ] CosmosDB Connection This probably only works when participants have access to the subscription
- [ ] Gateway installation vs ADF Runtime integration
- [ ] Document PowerBi Setup
- [ ] Filter out SO in Euro
- [ ] Only extract orders with customergroup Z1, Z2
- [ ] ML Algorithm
- [ ] Document ML Algorithm
