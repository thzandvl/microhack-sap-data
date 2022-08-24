# Extract Sales Order Headers using the SAP ODP Adapter

In this section we'll extract the Sales Headers using an ABAP CDS View and the SAP ODP Adapter.

The ABAP CDS View can be found [here](scripts/zbd_i_salesdocument_e1.asddls).
Note the annotations by which the CDS View can be found in the SAP Data Dictionary (transaction SE11 or SE11n) and the annotations for Data Extraction and Delta Enablement.
Here you can see that the field 'LastChangeDateTime' is used for Delta retrievals by the ODP adapter.

```
@AbapCatalog.sqlViewName: 'ZBD_ISALESDOC_E1'
@Analytics.dataExtraction.enabled: true
@Analytics.dataExtraction.delta.byElement.name:'LastChangeDateTime'
```

## Synapse SQL Table to receive the Sales Order Headers
The extracted Sales Order headers will be saved in a SQL Table within the Synapse SQL Pool.
We will begin with creating this table using an SQL Script.

* In the Azure Portal, select your Synapse Workspace.
* Select `Open Synapse Studio`
<img src="images/synapsews/openAzureDataStudio.jpg">

* Select 'Develop'
<img src="images/synapsews/SynapseStudioDevelop.jpg">

* Create SQL Script
<img src="images/synapsews/createSQLScript.jpg">

> Note: Make sure to change the "Connect to" value from 'builtin' to your own SQL pool as shown in the screenshot below. As by default it will be connected to the 'builtin' SQL pool of Synapse.

><img src="images/synapsews/connectToPool.jpg"

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
	-- MANDT int,
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

# Implement the Sales Order Header Pipeline

<img src="images/synapsews/SalesOrderHeaderPipeline.jpg">

The sales order headers are extracted from SAP using the SAP ODP Adapter which uses an RFC.
The CDS View to extract from is : `ZBD_ISALESDOC_E`.
>Note: You can have a look in the SAP system to check the contents. Use the Data Dictionary, transaction `SE11`.

## Create a Linked Service to the SAP System
* In Synapse Studio, go to the `Manage` View

<img src="images/irt/syn-irt1.png" height=200>

* Select `Linked Services`

<img src="images/synapsews/LinkedServices.jpg">

* Create a new `Linked Service` of type `SAP ODP Connector`

<img src="images/synapsews/SAPODP.jpg">

* Enter the connection details for the SAP System, we used the name `S4DCLNT100ODP`. Use the username and password for the SAP system provided to you at the start of the Microhack.
* Use the Integration Runtime which you installed in the previous steps
* Enter a Subscriber Name. This name will also be used by ODP in the SAP System.

<img src="images/synapsews/LS_SAPODP.jpg" height=800>

>Note : use `Test Connection` to verify your settings

>Note : SAP Connection Details will be handed out before the MicroHack

## Select the data to extract
Create an Integration DataSet based on the previously created `Linked Service`.
This dataset will act as the source.
* Switch to the `Data` View
* Create a new `Integration Dataset`

<img src="images/synapsews/IntegrationDataSet.jpg">

* Use type `SAP ODP`

<img src="images/synapsews/IS_SAPODP.jpg" height=300>

* Use your previously created Linked ODP Service for the SAP System, as name we used `S4DCLNT100ODP`
* Since we'll be extracting from a CDS View, use `ABAP_CDS` as context
* Use `ZBD_ISALESDOC_E$*` as table, it can take some time before the list of tables is loaded
* Use `Preview Data` to check if the data can be retrieved

<img src="images/synapsews/LS_ODPDSPreview.jpg">

* Once the information is entered successfully and the data can be retrieved, leave the tab as-is. We will publish the changes after the rest of the components of this data flow are done.

> Note : the source code of the CDS View can be found [here](scripts/zbd_i_salesdocument_e.asddls)

## Create a Linked Service to the Synapse SQL Pool
* this will represent the target/sink of the pipeline

* Switch to the `Manage` view

* Create a new Linked Service of type `Azure Synapse Analytics`, as name we used `SynMicroHackPool`

<img src="images/synapsews/syn3.jpg" height=300>

<img src="images/synapsews/LS_SQLPool.jpg" height=800>

>Note: Since this linked service represents the Synapse SQL pool, it will be re-used in the `SalesOrderItems`and `Payments` pipeline.

### Create an Integration DataSet for the Synapse Sales Orders
This dataset will act as the `sink` in our pipeline.
* Switch to the `Data`View

* Create a new `Integration DataSet` for the Synapse Sales Orders

<img src="images/synapsews/syn4.jpg" height=300>

* As a name we used `SynSalesOrderHeaders` and for the linked service we used the one we just created `SynMicroHackPool`

* Select the `SalesOrderHeaders` table

<img src="images/synapsews/syn5.jpg" height=300>

* Again leave the information on the tab as-is and move to the next step

## Create an Integration pipeline
* Swith to the `Integrate` view

<img src="images/synapsews/syn6.jpg" height=300>

* Create a new `Pipeline`, we used `ExtractSalesOrderHeaders` as a name

<img src="images/synapsews/pipelineView.jpg">

* Use the `copy action` by dragging it onto the pipeline canvas

<img src="images/synapsews/copyAction.jpg">

* In the `source` tab, select your SAP Sales Order Header Dataset as the source
* As `Extraction mode` select `Delta`
>Note : selecting the Delta extraction method will in a first run of the pipeline execute an Initial download and in subsequent runs execute Delta downloads, only containing changed objects since the last extraction.
* Enter a Subscriber process

<img src="images/synapsews/ODPCopyActionSource.jpg">


* In the `sink` tab, select the Synapse Sales Order Dataset as the sink
* As `Copy method` select `Upsert`
* As `Key Columns` select `SALESDOCUMENT`

<img src="images/synapsews/ODPCopyActionSink.jpg">

>Note : `Upsert` ensures that when executing a delta load, new records are inserted and changed records are updated. The `Key Columns` are used when determining if a record is to be newly inserted or needs to be updated.
>Note : In this example with Sales Order Headers, we assume Sales Order Headers can not be physically deleted from the DB. If this would be the case then a simple `Upsert` is not sufficient, since it can not take care of deletes. Also when there would be multiple changes to the same Sales Order Headers between extractions then the `Upsert` is not sufficient, since it does not take the update sequence into account. Better is to use the predefined template which differentiates between Insert, Update, Deletes and takes to update sequence into account. This is all info provided by the SAP ODP Layer.

* In the mapping tab, choose `Import schemas`. Since source and target fields have the same name, the system can auto-generate the mapping
 
<img src="images/synapsews/ODPAutoMapping.jpg">

* In the `Settings` blade, `enable staging` and use the existing Linked Service to the Synapse Data Lake.

* Enter the path to the staging directory of your Azure Data Lake. The staging directory `sap-data-adls/staging`, was already created by the Terraform script.

<img src="images/synapsews/staging.jpg" height=400>

* Now `Publish all` and once this is successful trigger the pipeline, use `Add trigger` -> `Trigger now` -> `OK`

<img src="images/synapsews/syn7.jpg" height=200>

<img src="images/synapsews/triggerNow.jpg">

* Swith to the `Monitor`view to monitor the pipeline run

<img src="images/synapsews/pipelineMonitor.jpg">

* Check the result in Synapse using SQL. You can do this via the `Develop` view and create a new SQL script.

```sql
select count(*) from SalesOrderHeaders
select * from SalesOrderHeaders
```

>Note : In the SAP BackEnd you can use transaction `ODQMON - Monitor for Operational Delta Queue` to monitor the ODP extractions.

<img src="images/synapsews/SAPODQMONTransAction.jpg">

You can now continue with (Extracting Sales Order Line items)[ExtractSalesOrderLineItemsUsingOData.md]

## Optional - Delta Changes
Since our ODP connector (and CDS View) allows for delta changes, you can change a Sales Order.
* Use Transaction `VA02 - Change Sales Order`
* Change the `Cust. Reference`field in the Sales Order Header

<img src="images/synapsews/SAPChangeCustReference.jpg">

* Rerun the extraction pipeline
* Change the `SalesDocument`in the sql script beneath to the changed Sales Order

```sql
select PURCHASEORDERBYCUSTOMER from SalesOrderHeaders WHERE SalesDocument = '0000000004'
```

* Verify the result by running the sql script

You can now continue with (Extracting Sales Order Line items)[ExtractSalesOrderLineItemsUsingOData.md]