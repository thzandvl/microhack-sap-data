# SAP Microhack: CashFlow Prediction
## Summary
For this Microhack we will:
* Extract (Historical) Sales Orders from SAP S/4HANA and load this in Synapse
* Upload historical payments from a non-SAP system, in this example Cosmos DB, to Synapse
* Visualize the extracted Sales Orders and invoice data with Power BI
* Predict incoming cash flow for new Sales Orders

## Scenario Description
When customers buy goods, the corresponding payments are not done immediatly. Some customers will pay directly and other customers will pay at end of the payment terms. This makes it diffucult for companies to predict the incoming cashflow. In this simplified exercise we'll use Azure tooling to predict the incoming cashflow. For this we need data on past Sales Orders and past payments. The Sales Order information we'll retrieve from a S4Hana ssytem. For the payments we assume they are kept in a non SAP system. This non SAP System is represented by a cosmos DB.

## Get Started
To start with the Microhack we first need to take some preparation steps:

0. [Software Prerequisites](SoftwarePrerequisites.md)
1. [Deploy a Integration Runtime for the SAP RFC connection](DeployIntegrationRuntimeVM.md)
2. [Prepare the Integration Runtime server](PrepareIntegrationRuntime.md)
3. [Synapse Workspace Setup](SynapseWorkspace.md)
4. [PowerBI Visualisation](PowerBiVisualisation.md)
5. [Predict Cash Flow](Predict CashFlow.md)



