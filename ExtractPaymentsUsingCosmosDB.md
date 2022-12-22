# Extract Payments using the CosmosDB Adapter

In this section we'll extract the Payments from CosmosDB and store them in a Synapse Table.

<img src="images/synapsews/PaymentsPipeline.jpg">

## Synapse SQL Table to receive the Payments
The extracted Payments will be saved in a SQL Table within the Synapse SQL Pool.
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

## Create Linked Service for CosmosDB
* Create a Linked Service of type CosmosDB (SQL API)

<img src="images/synapsews/cosmosDBSSQLapi.jpg" height=100>

* Enter the connection parameters, as name we use `CosmosSAPS4D`

Azure Cosmos DB account URI : `<handed out at micro hack>`

Azure Cosmos DB access key : `<handed out at micro hack>`

Database name : `SAPS4D` 

<img src="images/synapsews/LS_CosmosDB.jpg" height=600>

* Test the connection and create the linked service.


## Create a Integration DataSet for the CosmosDB Payments
This dataset will act as the source for our pipeline.
* Create a `source` DataSet for the Payment Data based on the CosmosDB `SQL API` Adapter

<img src="images/synapsews/syn10.jpg" height=300>

* As name we use `CosmosPaymentData`. Use collection : `paymentData`.

<img src="images/synapsews/cosmosPaymentDS.jpg" height=300>


## Create a Integration DataSet for the Synapse Payments
This dataset will act as the sink for our pipeline
* Create a `Integration DataSet` based on `Azure Synapse Analytics`

<img src="images/synapsews/syn11.jpg" height=300>

* As name we use `SynPayments`. Select the `Payments` table

## Create the Integration pipeline for the Payment flow
* Go to the `Integrate` view
* Add a new `Pipeline`
* Use the `Copy` action and name it `ExtractPayments`
* As source select the Cosmos DB payment Dataset, we named this `CosmosPaymentData`.
* As sink, select the Synapse Payment DataSet. We named this `SynPayments`. As Copy method choose `PolyBase`.
* Under the `Settings` tab enable and configure the `Staging Area` as done in the earlier pipelines
* Go to the tab `Mapping` and choose `Import schemas`. Make sure to remove the mappings which are not shown in the screenshot starting with `_`, you can remove them my unchecking the checkbox behind them. Do not forget to change the `Column name` for `Value` to `PaymentValue`.

<img src="images/synapsews/paymentMapping.jpg">

* Create, publish and trigger the integration pipeline
* Check the result in Synapse using SQL

```sql
select count(*) from Payments
select * from Payments
```

You can now proceed with the [PowerBI Visualisation](PowerBiVisualisation.md) step.