# Synapse Workspace

## Introduction

## Creation
* Create a Synapse Analytics Workspace
<img src="images\synapsews\synapsewsservice.jpg">

Enter the following settings :
Basics :
* Resource Group
* Worksapce Name
* Data Lake Storage : Select an existing DL or create a new one
* File System Name : Select an exising File System or create a new one

<img src="images\synapsews\synapsewsservice_basics.jpg">

Security :
* Admin Username & Password : this will be there user id and password for the related SQL DB's.

<img src="images\synapsews\synapsewsservice_security.jpg">

Other settings can remain as default.

After deployment :
Create a `staging' directory within the Synapse Azure Data Lake container. This directory is used for temporary files during data upload to Synapse.

<img src="images\synapsews\stagingDirectory.jpg">

Create a new SQL Pool
Choose `DW100c` as performance level (to save on costs)

<img src="images\synapsews\createSQLPool.jpg">

# Synapse Configuration
The configuration is done 'Synapse Studio'.
<img src="images\synapsews\openSynapseStudio.jpg">

* Register Integration Runtime
Register the integration runtime
<img src="images\synapsews\integrationRuntimes.jpg">

* Implement SalesOderHeaders flow
The sales order headers are extracted from SAP using the SAP Table Adapter which uses a RFC.
The view to extract from is : `ZBD_ISALESDOC_E`. You can have a look in the SAP system to check the contents. Use the Data Dictionary, transaction `SE11`.

1. Create a Linked Service to the SAP System.

<img src="images\synapsews\LS_SAPRFC.jpg">

2. Select the data to extract
Create an Integration DataSet based on the previously create `Linked Service`.
This dataset will act as the source.
<img src="images\synapsews\S4DSalesOrderHeadersDS.jpg">

3. Create a Integration DataSet for the Synapse Sales Orders.
This dataset willa ct as the 'sink'.
<img src="images\synapsews\SynSalesOrderHeadersDS.jpg">

4. Create a Integration pipeline
Use the copy action. Map the source to the SAP Sales Order dataset and the sink to the synapse Sales Order dataset.
<img src="Images\synapsews\copyAction.jpg">

<img src="Images\synapsews\RFCCopyActionSource.jpg">

<img src="Images\synapsews\RFCCopyActionSink.jpg">

In the mapping tab, select `import Mapping`. Since source and target fields have the same name, the system can auto-generate the mapping.

<img src="images\synapsews\rfcMapping.jpg">

For date and time fields we need to make sure the system maps these to the SQL Date fields. Therefore, go to the JSOn Code and add :

```json
  "typeProperties": {
                    "source": {
                        "type": "SapTableSource",
                        "partitionOption": "None",
                        "convertDateToDatetime": true,
                        "convertTimeToTimespan": true
                    },
                    "sink": {
                        ...
```

In the `Settings` blade, enable staging and enter the path to the staging directory of Azure Data Lake .
<img src="images\synapsews\staging">

Now, you can publish and trigger the pipeline

<img src="images\synapsews\triggerNow.jpg">

Monitor the pipeline.



* Implement the SalosOrderItems flow
The SalesOrderItems are extracted from SAP using the SAP ECC Connector which is based on oData
1. Create a Linked Service to SAP oData
<img src="images\synapsews\LS_SAPOdata.jpg">

2. Create a 'source' DataSet for the Sales Order Items, based on `SAP ECC adapter`.
Use `C_Salesorderitemfs`as path.
<img src="images\synapsews\S4DSalesOrderItemsDS.jpg">


* Implement the Payment flow
Payments are extracted from CosmosDB
1. Create a Linked Service to CosmosDB (SQL API)
<img src="images\synapsews\LS_cosmosDB">

Test the connection and create the linked service.

2.Create a 'source' DataSet for the Payment Data based on the CosmosDB 'SQL API' Adapter
Use collection : `paymentData`
<img src="images\synapsews\cosmosPaymentDS.jpg">

