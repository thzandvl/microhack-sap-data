# Extract Sales Order Headers using the SAP Table Adapter

In this section we'll extract the Sales Headers using an ABAP CDS View and the SAP Table Adapter.

The ABAP CDS View can be found [here](scripts/zbd_i_salesdocument_e.asddls).
Note in the annotations the ABAP Dictionary name by which the CDS View can be found in the SAP Data Dictionary (transaction SE11 or SE11n)/

```
@AbapCatalog.sqlViewName: 'ZBD_ISALESDOC_E'
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

# Implement the Sales Order Header Pipeline

<img src="images/synapsews/SalesOrderHeaderPipeline.jpg">

The sales order headers are extracted from SAP using the SAP Table Adapter which uses an RFC.
The CDS View to extract from is : `ZBD_ISALESDOC_E`.
>Note: You can have a look in the SAP system to check the contents. Use the Data Dictionary, transaction `SE11`.

## Create a Linked Service to the SAP System
* In Synapse Studio, go to the `Manage` View

<img src="images/irt/syn-irt1.png" height=200>

* Select `Linked Services`

<img src="images/synapsews/LinkedServices.jpg">

* Create a new `Linked Service` of type `SAP Table Connector`

<img src="images/synapsews/SAPODP.jpg">

* Enter the connection details for the SAP System, we used the name `S4DCLNT100ODP`. Use the username and password for the SAP system provided to you at the start of the Microhack.
* Use the Integration Runtime which you installed in the previous steps

<img src="images/synapsews/LS_SAPODP.jpg" height=800>

>Note : use `Test Connection` to verify your settings

>Note : SAP Connection Details will be handed out before the MicroHack

## Select the data to extract
Create an Integration DataSet based on the previously created `Linked Service`.
This dataset will act as the source.
* Switch to the `Data` View
* Create a new `Integration Dataset`

<img src="images/synapsews/IntegrationDataSet.jpg">

* Use type `SAP Table`

<img src="images/synapsews/syn1.jpg" height=300>

* Use your previously created Linked Service for the SAP System (Table connector), as name we used `S4DCLNT100`

* Use `ZBD_ISALESDOC_E` as table, it can take some time before the list of tables is loaded

* Use `Preview Data` to check if the data can be retrieved

<img src="images/synapsews/syn2.jpg">

* Once the information is entered succesfully and the data can be retrieved, leave the tab as-is. We will publish the changes after the rest of the components of this data flow are done.

> Note : the source code of the CDS View can be found [here](scripts/zbd_i_salesdocument_e.asddls)

## Create a Linked Service to the Synapse SQL Pool
* this will represent the target/sink of the pipeline

* Switch to the `Manage` view

* Create a new Linked Service of type `Azure Synapse Analytics`, as name we used `SynMicroHackPool`

<img src="images/synapsews/syn3.jpg" height=300>

<img src="images/synapsews/LS_SQLPool.jpg" height=800>

>Note: Since this linked service represents the Synapse SQL pool, it will be re-used in the `SalesOrderItems`and `Payments` pipeline.

## Create an Integration DataSet for the Synapse Sales Orders
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

* In the `source` tab, select your SAP Sales Order Dataset as the source

<img src="images/synapsews/RFCCopyActionSource.jpg">

* In the `sink` tab, select the Synapse Sales Order Dataset as the sink

<img src="images/synapsews/RFCCopyActionSink.jpg">

>Note : Ensure to select `PolyBase`

* In the mapping tab, choose `Import schemas`. Since source and target fields have the same name, the system can auto-generate the mapping

<img src="images/synapsews/rfcMapping.jpg">

* For the prediction model we will calculate the offset between the billing document date and the actual payment data. For this we need to have these date fields mapped to SQL Date fields. Therefore, go to the JSON Code for the pipeline and add `convertDateToDateTime` and `convertTimeToTimespan` parameters.

<img src="images/synapsews/jsonCodeButton.jpg">

Add the parameters `convertDateToDatetime` and `convertTimeToTimespan` at the existing `typeproperties > source` element. The resulting document should looks as follows :
```javascript
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
<!-- >>Note : if these parameters are not entered correctly the date fields will remain as a String format. -->
<!-- Note : these are internal parameters!!! -->

* In the `Settings` blade, `enable staging` and use the existing Linked Service to the Synapse Data Lake.

* Enter the path to the staging directory of your Azure Data Lake. The staging directory `sap-data-adls/staging`, was already created by the Terraform script.

<img src="images/synapsews/staging.jpg" height=400>

* Now `Publish all` and once this is successfull trigger the pipeline, use `Add trigger` -> `Trigger now` -> `OK`

<img src="images/synapsews/syn7.jpg" height=200>

<img src="images/synapsews/triggerNow.jpg">

* Swith to the `Monitor`view to monitor the pipeline run

<img src="images/synapsews/pipelineMonitor.jpg">

* Check the result in Synapse using SQL. You can do this via the `Develop` view and create a new SQL script.

```sql
select count(*) from SalesOrderHeaders
select * from SalesOrderHeaders
```
