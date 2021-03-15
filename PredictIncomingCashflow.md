# Predict Incoming Cashflow
In this section we'll setup some example powerBi reports.

We'll be using [PowerBI Desktop](https://powerbi.microsoft.com/en-us/desktop/) for this.

## Setup & Importing Data
In Synapse Studio, we will create a view to store data coming from `SalesOrderHeaders` and `Payments` tables that will be used for the prediction.
* Choose the `Develop`tab, select `SQL Scripts` and click on `Actions` then `New SQL Script`.\
<img src="images/powerBi/getdata.jpg" height=100>

* In the newly created script tab, copy paste the following SQL Query that will execute a join between `SalesOrderHeaders` and `Payments` to create a new view.
`CREATE VIEW [dbo].[SalesPaymentsFull]
	AS SELECT s.[SALESDOCUMENT]
    , s.[CUSTOMERNAME]
    , s.[CUSTOMERGROUP]
    , s.[BILLINGCOMPANYCODE]
    , s.[BILLINGDOCUMENTDATE]
    , p.[PaymentDate] as PAYMENTDATE
    , s.[CUSTOMERACCOUNTGROUP]
    , s.[CREDITCONTROLAREA]
    , s.[DISTRIBUTIONCHANNEL]
    , s.[ORGANIZATIONDIVISION]
    , s.[SALESDISTRICT]
    , s.[SALESGROUP]
    , s.[SALESOFFICE]
    , s.[SALESORGANIZATION]
    , s.[SDDOCUMENTCATEGORY]
    , s.[CITYNAME]
    , s.[POSTALCODE]
    , DATEDIFF(dayofyear, s.BILLINGDOCUMENTDATE, p.PaymentDate) as PAYMENTDELAYINDAYS
 FROM [dbo].[SalesOrderHeaders] as s
JOIN [dbo].[Payments] as p ON REPLACE(LTRIM(REPLACE(s.[SALESDOCUMENT], '0', ' ')), ' ', '0') = p.[SalesOrderNr]`

<img src="images/powerBi/sqlendpoint.jpg" height=100>\

## Aure Machnie Learning

* Sign in to Azure Machine Learning at https://ml.azure.com
<img src="images/powerBi/synapseconnection.jpg" height= 175>
* Use your Azure credentials to logon or the userid and password used during the Synapse Workspace creation.

* Select the 3 tables created in the previous steps.

<img src="images/powerBi/dataselection.jpg" height= 300>

* Select `Transform Data`\
In order for all 3 tables to have the same sales order number, we'll convert the sales order number from string to integer.
In the 3 tables select the sales order number column and change the type to `Whole Number`.\
<img src="images/powerBi/whole_number.jpg">\
The `formula`for the column will then change to `Table.TransformColumnTypes(dbo_SalesOrderItems,{{"SalesOrder", Int64.Type}})`.\
For `SalesOrderHeaders`, change the `SALESDOCUMENT` column. The transformation will remove the leading zeros.\
For `SalesOrderItems`, change the `SalesOrder` column.\
For `Payments`, change the `SalesOrderNr`column.

* Select `Close and Apply`. 

## Create the Relational Model
In this step we'll model the relationships between the tabels.
The Relationships are as follows :

`SalesOrderHeader 1:n SalesOrderItems`\
`Payment 1:1 SalesOrderHeader`
