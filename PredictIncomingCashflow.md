# Predict Incoming Cashflow
In this section we'll create a model to predict incoming cashflow based on historical payment delays for previous sales.

We'll be using [Azure Machine Learning](https://ml.azure.com) for this.

## Setup in Synapse
In Synapse Studio, we will create a view joining data coming from `SalesOrderHeaders` and `Payments` tables that will be used for the prediction. 
You can create this view either via Synapse Studio or via Azure Data Studio.

* Choose the `Develop` tab, select `SQL Scripts` and click on `Actions` then `New SQL Script`.
<img src="images/aml/01-synapse-query.PNG" height=200>

> Note : Ensure to connect to your SQL Pool

* In the newly created script tab, copy paste the following SQL Query that will execute a join between `SalesOrderHeaders` and `Payments` to create a new view.

```sql
CREATE VIEW [dbo].[SalesPaymentsFull]
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
JOIN [dbo].[Payments] as p ON REPLACE(LTRIM(REPLACE(s.[SALESDOCUMENT], '0', ' ')), ' ', '0') = p.[SalesOrderNr]
```

After `Refresh`the view will appear under `Views`.

<img src="images/aml/01a-synapse-query.PNG" height=300>

You can now test the view.

<img src="images/aml/01b-synapse-query.PNG" >

## Azure Machine Learning

* You will first have to create a Azure Machine Learning Workspace.
* In the azure portal search for `Azure Machine Learning`and select `create`

<img src="images/aml/azure_ml_icon.jpg">

<img src="images/aml/02a-aml-ws-setup.PNG" height= 400>

* Enter the 'Resource Group' you've been using before or create a new one. 
* Enter a `Workspace Name`
* Select the `Region`you've been using

You can now open the ML Studio from here or alternatively sign in via https://ml.azure.com.

<img src="images/aml/02-aml-studio.PNG" height= 400>

### DataStore Creation
First you have to point the ML studio to the location of your data, which is the Synapse SQl Pool. For this you have to create a `DataStore`
<img src="images/aml/dsMenu.jpg" height=600>
<img src="images/aml/synapseDS.jpg" height=600>

### Automated ML
We'll be using `Automated Machine Learning` to predict when customers will pay for their Sales Orders/

* On the left menu, click on `Automated ML`,
<img src="images/aml/automated_ml.jpg" height= 300>

* Select `New Automated ML Run`
* Select `Create Dataset` > `From datastore`
<img src="images/aml/dataSetFromDataStore.jpg" height=300>

A Guided Procedure will appear :
* <b>Basic info : </b> Provide a Name for the `Dataset`
<img src="images/aml/03-aml-studio.PNG" height= 200>
* <b>DataStore Selection : </b> Select your datastore.
<img src="images/aml/dsSelection.jpg" height= 200>


* Use the following SQL query to get all the data.
```sql
SELECT * FROM SalesPaymentsFull
```

<img src="images/aml/05-aml-studio.PNG" height= 200>

* <b>Settings and Preview :</b> To Ensure that your query is working fine you are able to visualize the data in the next window.
<img src="images/aml/06-aml-studio.PNG" height= 400>

* <b>Schema :</b> In order to get a model as accurate as possible we have to do some cleaning of the data.
<img src="images/aml/07-aml-studio.PNG" height= 400>

1. Select an Integer type for any numeric field. <!--???Is this needed???-->

2. Uncheck the date fields that we will not use in the model. (`BILLINGDOCUMENTDATE`, `PAYMENTDATE`)
<img src="images/aml/08-aml-studio.PNG" height= 400>

3. Uncheck the fields that do not contain any data or which are not relevant for the forecast. Eg. `SALESDOCUMENT`, `SALESGROUP`, `SALESOFFICE` <!-- Can we also uncheck Sales Document??? -->
<img src="images/aml/09-aml-studio.PNG" height= 400>

* <b>Confirm details</b> Create the dataset
<img src="images/aml/10-aml-studio.PNG" height= 400>

## Configure the Automated ML Run
* Select the newly created `Dataset` and create a new experiment.
<img src="images/aml/11-aml-studio.PNG" height= 200>

1. Specify a name.
2. Select the `Target Column` : in our case we will use `PAYMENTDELAYINDAYS` to predict the forecast.

3. Create a new compute that will be used to train your model.
<img src="images/aml/12-aml-studio.PNG" height= 400>
<img src="images/aml/13-aml-studio.PNG" height= 400>
<img src="images/aml/14-aml-studio.PNG" height= 400>

* We can now select the ML task type we want to use for this experiment, as we want to build prediction on a numeric value we will select the `Regression` task type. 
<img src="images/aml/15-aml-studio.PNG" height= 400>

* Then we need to configure the `Regression` using `Additional Configuration settings`.
1. Select `Normalized root mean squared error` as Primary metric.
<img src="images/aml/16-aml-studio.PNG" height= 400>

2. Select all the following algorithms as blocked (useless for the regression task type) : `ElasticNet, GradientBoosting, DecisionTree, KNN, LassoLars, SGD, RandomForest, ExtremeRandomTrees, LightGBM, TensorFlowLinearRegressor, TensorFlowDNN`.

<!-- BDL : Mismatch with my algorithms -->

3. Validate and click on `Finish`.
<img src="images/aml/17-aml-studio.PNG" height= 400>
<img src="images/aml/18-aml-studio.PNG" height= 400>

4. During the run you can follow-up on the tested models via the `Models` tab
<img src="images/aml/mlModelsTab.jpg" height = 300>

## Deploy the best model
In this step we will deploy the best model that has been trained by AutoML and test it.

* When the training is over, you can see the `Best model summary` section filled with the best algorithm, click on it.
<img src="images/aml/19-aml-studio.PNG" height= 400>

* You can navigate into the different sections and visualize the information about this algorithm, then click on deploy.
<img src="images/aml/20-aml-studio.PNG" height= 400>

* Specify a name for your deployment and select `Azure Container Instance` as compute type.
<img src="images/aml/21-aml-studio.PNG" height= 400>

* Validate and wait for the completion of the deployment.
<img src="images/aml/22-aml-studio.PNG" height= 400>

* When completed, click on the link to the `Deploy status` of the deployed model.
<img src="images/aml/23-aml-studio.PNG" height= 400>

* In this page, you will have access to the different information of your endpoint, code samples to consume it from Python or C# but also a page to directly test your model.
<img src="images/aml/24-aml-studio.PNG" height= 400>

## Test the Prediction
Select the `Test` tab and insert values coming from the `SalesPaymentsFull` view created at the beginning to replace the `example_value` value for the different fields and run the model.

<img src="images/aml/25-aml-studio.PNG" height= 400>

From the PowerBI section, we know that the main factor in determining the payment dely is the CustomerGroup. Experiment with CustomerGroup `Z1` and `Z2` to see if the outcome is similar.