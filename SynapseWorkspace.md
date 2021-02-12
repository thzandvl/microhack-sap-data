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
* Create a `staging' directory within the Synapse Azure Data Lake container. This directory is used for temporary files during data upload to Synapse.

<img src="images\synapsews\stagingDirectory.jpg">

* Create a new SQL Pool
Choose `DW100c` as performance level (to save on costs).

<img src="images\synapsews\createSQLPool.jpg">

* Create the Synapse tables in the SQL Pool
These tables are the receivers of the SAP Sales Order data and the Cosmos Payment Data.
Use the following SQl Scripts to create the tables.
You can this via the Synapse workspace or use the [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio).

- SalesOrderHeaders
```sql
CREATE TABLE SalesOrderHeaders(
	BILLINGCOMPANYCODE nvarchar(4),
	BILLINGDOCUMENTDATE date,
	COUNTRY nvarchar(3),
	CREATIONDATE date,
	CREATIONTIME time,
	CREDITCONTROLAREA nvarchar(4),
	CUSTOMERACCOUNTGROUP nvarchar(4),
	CUSTOMERGROUP nvarchar(2),
	CUSTOMERNAME nvarchar(80),
	DISTRIBUTIONCHANNEL nvarchar(2),
	LASTCHANGEDATE date,
	LASTCHANGEDATETIME decimal(21,0),
	MANDT int,
	ORGANIZATIONDIVISION nvarchar(2),
	PRICINGDATE date,
	PURCHASEORDERBYCUSTOMER nvarchar(35),
	SALESDISTRICT nvarchar(6),
	SALESDOCUMENT nvarchar(10) NOT NULL,
	SALESDOCUMENTPROCESSINGTYPE nvarchar(1),
	SALESDOCUMENTTYPE nvarchar(4),
	SALESGROUP nvarchar(3),
	SALESOFFICE nvarchar(4),
	SALESORGANIZATION nvarchar(4),
	SDDOCUMENTCATEGORY nvarchar(4),
	SOLDTOPARTY nvarchar(10),
	TOTALNETAMOUNT decimal(15, 2),
	TRANSACTIONCURRENCY nvarchar(5),
	CITYNAME nvarchar(35),
	POSTALCODE nvarchar(10)
)
```
- SalesOrderItems
```sql
CREATE TABLE SalesOrderItems(
    SalesOrder nvarchar(10),
    SalesOrderItem nvarchar(6),
    SalesOrderItemText nvarchar(40),
    SoldToParty nvarchar(10),
    MaterialByCustomer nvarchar(35),
    MaterialName nvarchar(40),
    Material nvarchar(40),
    ShipToParty nvarchar(10),
    FullName nvarchar(80),
    SDProcessStatus nvarchar(1),
    DeliveryStatus nvarchar(1),
    SDDocumentRejectionStatus nvarchar(1),
    SalesDocumentRjcnReason nvarchar(2),
    RequestedQuantity decimal(15,3),
    RequestedQuantityUnit nvarchar(3),
    TransactionCurrency nvarchar(5),
    NetAmount decimal(16, 3),
    MaterialGroup nvarchar(9),
    Batch nvarchar(10),
    ProductionPlant nvarchar(4),
    StorageLocation nvarchar(4),
    ShippingPointName nvarchar(30),
    ShippingPoint nvarchar(4),
    SalesOrderItemCategory nvarchar(4),
    BillingBlockCriticality tinyint,
    ItemBillingBlockReason nvarchar(2),
    OrderRelatedBillingStatus nvarchar(1),
    RequestedDeliveryDate date,
    HigherLevelItem nvarchar(6),
    SalesOrderProcessingType nvarchar(1),
    RequirementSegment nvarchar(40)
)
```

- Payments
```sql
CREATE TABLE Payments(
	PaymentNr nvarchar(10),
	SalesOrderNr nvarchar(10),
	CustomerNr nvarchar(10),
	CustomerName nvarchar(80),
	PaymentDate date,
	PaymentValue decimal(15,2),
	Currency nvarchar(5)
)
```



# Synapse Configuration
The configuration is done via `Synapse Studio`:\
<img src="images\synapsews\openSynapseStudio.jpg">

## Register Integration Runtime
To register the integration runtime click on manage:
<img src="images\irt\syn-irt1.png" height="300px" />

Click on `Integration runtimes`:
![Integration runtimes](/images/irt/syn-irt2.png)

Click on `+ New`:
![New integration runtimes](/images/irt/syn-irt3.png)

Choose `Self-Hosted`:
![Integration runtime setup](/images/irt/syn-irt4.png)

Choose a name for the runtime installation:
![Integration runtime name](/images/irt/syn-irt5.png)

You will receive two key values. Make sure to note these down, in the next step you need one of these keys.
![Integration runtime keys](/images/irt/syn-irt6.png)

In `Option 2: Manual setup` you can download the integration runtime via `Step 1`, do so. 

Login on the Gateway VM and copy the integration runtime MSI package to the download folder, or any other folder you prefer.
Execute the MSI package and press next until you get the question for the `authentication key`:

![Integration runtime configuration: key](/images/irt/gw-irt1.png)

Enter one of the keys you noted down earlier from integration runtime setup and choose `Register`.

Enter the name of the integration runtime node configured earlier.
![Integration runtime configuration: node](/images/irt/gw-irt2.png)
Choose `Finish`.

![Integration runtime configuration: status](/images/irt/gw-irt3.png)
The installation is done and the node is connected and can be used.

# Implement SalesOderHeaders flow
The sales order headers are extracted from SAP using the SAP Table Adapter which uses a RFC.
The view to extract from is : `ZBD_ISALESDOC_E`. You can have a look in the SAP system to check the contents. Use the Data Dictionary, transaction `SE11`.

* Create a Linked Service to the SAP System.

<img src="images\synapsews\LS_SAPRFC.jpg">

* Select the data to extract
Create an Integration DataSet based on the previously create `Linked Service`.
This dataset will act as the source.
<img src="images\synapsews\S4DSalesOrderHeadersDS.jpg">

* Create a Linked Service to the SQL Pool

<img src="images\synapsews\LS_SQLPool.jpg">

* Create a Integration DataSet for the Synapse Sales Orders.
This dataset will act as the 'sink'.
<img src="images\synapsews\SynSalesOrderHeadersDS.jpg">

* Create a Integration pipeline
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

* publish and trigger the pipeline

<img src="images\synapsews\triggerNow.jpg">

* Monitor the pipeline.
* Check the result using SQL
```sql
select count(*) from SalesOrderHeaders
select * from SalesOrderHeaders
```


# Implement the SalosOrderItems flow
The SalesOrderItems are extracted from SAP using the SAP ECC Connector which is based on oData
* Create a Linked Service to SAP oData
<img src="images\synapsews\LS_SAPOdata.jpg">

* Create a 'source' DataSet for the Sales Order Items, based on `SAP ECC adapter`.
Use `C_Salesorderitemfs`as path.
<img src="images\synapsews\S4DSalesOrderItemsDS.jpg">

* Create, publish and trigger the integration Pipeline
* Check the result using SQL
```sql 
select count(*) from SalesOrderItems
select * from SalesOrderItems
```

# Implement the Payment flow
Payments are extracted from CosmosDB
* Create a Linked Service to CosmosDB (SQL API)
<img src="images\synapsews\LS_cosmosDB">

Test the connection and create the linked service.

* Create a 'source' DataSet for the Payment Data based on the CosmosDB 'SQL API' Adapter
Use collection : `paymentData`
<img src="images\synapsews\cosmosPaymentDS.jpg">

* Create a 'sink' DataSet for the payment Data in Synapse
* Complete the mapping between 'source' and 'sink' datasets.
<img src="images\synapsews\paymentMapping.jpg">

* Create, publish and trigger the integration pipeline
* Check the result using SQL
```sql
select count(*) from Payments
select * from Payments
```