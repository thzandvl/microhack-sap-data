# Predict Incoming Cashflow
In this section we'll setup some example powerBi reports.

We'll be using [PowerBI Desktop](https://powerbi.microsoft.com/en-us/desktop/) for this.

## Setup & Importing Data
In Synapse Studio, we will create a view to store data coming from `SalesOrderHeaders` and `Payments` tables that will be used for the prediction.
* Choose the `Develop`tab, select `SQL Scripts` and click on `Actions` then `New SQL Script`.\
<img src="images/aml/01. Synapse Query.png" height=200>

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


## Aure Machnie Learning

* Sign in to Azure Machine Learning at https://ml.azure.com \
<img src="images/aml/02. AML Studio.png" height= 200>
* Use your Azure credentials to logon or the userid and password used during the Synapse Workspace creation.

* On the left menu, click on `Automated ML`, then you will have to create a new datastore.\
<img src="images/aml/03. AML Studio.png" height= 200>

* Fill the needed information to connect to you Synapse Instance\
<img src="images/aml/04. AML Studio.png" height= 200>

* You can now select the newly created datastore and then use the following SQL query to get all the data\
`SELECT * FROM SalesPaymentsFull`\
<img src="images/aml/05. AML Studio.png" height= 200>

* To Ensure that your query is working fine you are able to visualize the data in the next window\
<img src="images/aml/06. AML Studio.png" height= 200>

* In order to get a model as much accurate as possible we have to do some cleaning of the data\
<img src="images/aml/07. AML Studio.png" height= 200>

1. Select an Integer type for any numeric field
2. Uncheck the date fields that we will not use in the model
3. Uncheck the fields that does not contain any data
<img src="images/aml/08. AML Studio.png" height= 200>
<img src="images/aml/09. AML Studio.png" height= 200>

* Validate the `Dataset` \
<img src="images/aml/10. AML Studio.png" height= 200>

* Select the newly created `Dataset` and create a new experiment.\
<img src="images/aml/11. AML Studio.png" height= 200>
1. Specify a name
2. Select the `Target Column` : in our case we will use `PAYMENTDELAYINDAYS` to predict the forecast
3. Create a new compute that will be used to train your model\
<img src="images/aml/12. AML Studio.png" height= 200>
<img src="images/aml/13. AML Studio.png" height= 200>
<img src="images/aml/14. AML Studio.png" height= 200>

* We can now select the ML task type we want to use for this experiment, as we want to build prediction on a numeric value we will select the `Regression` task type 
<img src="images/aml/15. AML Studio.png" height= 200>

* Then we need to configure it
1. Select `Normalized root mean squared error` as Primary metric\
<img src="images/aml/16. AML Studio.png" height= 200>
2. Select all the listed algorithms as blocked (useless for the regression task type)
3. Valide and click on `Finish`\
<img src="images/aml/17. AML Studio.png" height= 200>
<img src="images/aml/18. AML Studio.png" height= 200>

## Deploy the best model
In this step we will deploy the best model that has been trained by AutoML and test it

* When the training will be over, you will be able to see the `Best model summary`section filled with the best algorithm, click on it.\
<img src="images/aml/19. AML Studio.png" height= 200>

* You can navigate into the different sections and visualize the information about this algorithm, then click on deploy.\
<img src="images/aml/20. AML Studio.png" height= 200>

* Specify a name for your deployment and select `Azure Container Instance` as compute type.\
<img src="images/aml/21. AML Studio.png" height= 200>

* Validate and wait for the completion of the deployment.
<img src="images/aml/22. AML Studio.png" height= 200>


