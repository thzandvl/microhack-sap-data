# 4 - Integrate Azure Machine Learning and PowerBI

[< 3 Predict Cash Flow](./PredictIncomingCashflow.md) - **[🏠Home](./README.md)** - [ 5 Create Alerting Rule >](./CreateAlertingRule.md)

We can now integrate the ML Model within PowerBI. The Azure ML exposes a REST interface which we can integrate in powerBi.
> Note : for this example we'll predict the payment date of the 'Historical Sales Orders'. In real-life you would do this for new unpaid Sales Orders

## Add Machine Learning info to the PowerBI Data model

In this section we'll add a new column to `SalesOrderPayments` which will contain the `Payment Off/Delay` calculated by our Machine Learning Model.

* In PowerBI, select Transform Data
* Select the View `SalesOrderPayments` containing the combined SalesOrderHeader & Payments data
* Select `Azure Machine Learning` button

    <img src="images/aml/pbiAzMLIcon.jpg">

* Select your Azure Machine Learning Model
* Map the input fields of the Machine Learning Model to your column names

    <img src="images/aml/pbiMLMapping.jpg">

> Note : if you can't map the fields then you might need to change the data type of your columns. (Eg. `BILLINGCOMPANYCODE`, `DISTRIBUTIONCHANNEL`, `ORGANIZATIONDIVISION`, `SALESORGANIZATION`)

> Note: if you get a security warning, select the check-box to ignore future warnings for this file
    <img src="images/aml/securitywarning.jpg">


* This will add an additional column to the table with the predicted offset

* Rename the column to `predOffset` and change the date type to `Whole Number`

* You can now calculate the predicted payment date
    * Add a new custom column `predPaymentDate` and use the following formula

        ```
        Date.AddDays([BILLINGDOCUMENTDATE], [predOffset])
        ```

        <img src="images/aml/pbiMLPredPaymentDateColumn.jpg" height=400>

* Change the data type of this column to `Date`

* You can now use this column in reporting

## PowerBI Report Creation

We will now display the Sales & predicted payment forecast in PowerBI. Since we want to display the Sales and Payment figures aggregated by different days (`BILLINGDOCUMENTDATE`, `predPaymentDate`), we need to create a 'calendar' table with the timeslots by which to aggregate.

### Create Date Table

First we will create a new `Date` table. This table contains the timeline against which to plot the different Sales and Payment values.
In PowerBI switch to the `Data` View and select `New table`.

<img src="images/aml/newDateTable.jpg">

Use the formula beneath

```
Date= 
VAR MinYear = YEAR ( MIN ( 'SalesOrderPayments'[CREATIONDATE]) )
VAR MaxYear = YEAR ( MAX ( 'SalesOrderPayments'[predPaymentDate] ) )
RETURN
ADDCOLUMNS (
FILTER (
CALENDARAUTO( ),
AND ( YEAR ( [Date] ) >= MinYear, YEAR ( [Date] ) <= MaxYear )
),
"Calendar Year", "CY " & YEAR ( [Date] ),
"Year", YEAR ( [Date] ),
"Month Name", FORMAT ( [Date], "mmmm" ),
"Month Number", MONTH ( [Date] ),
"Year & Month", YEAR([Date]) & " - " & FORMAT ( [Date], "mmmm" )
)
```

Once added click on the `Check` to execute the forumla. 
<img src="images/aml/executeFormula.jpg">

### Create Relationships

Create relationships between the `Date` table and `SalesOrderPaymentsFull` table
* Date[Date] - SalesOrderPayments[CREATIONDATE] : this is the default (active) relationship
* Date[Date] - SalesOrderPayments[BILLINGDOCUMENTDATE]
* Date[Date] - SalesOrderPayments[Payments.PaymentDate]
* Date[Date] - SalesOrderPayments[predPaymentDate]

    <img src="images/aml/dateRelationships.jpg" height=300>

### Create new Measures

In the `Date` table, create new measures. Make sure to click on `New Measures` each time and confirm that the new measure is displayed on the right hand side. 
<img src="images/aml/NewMeasure.jpg">
```
Sales at CreationDate = sum('SalesOrderPayments'[TOTALNETAMOUNT])
```
```
Sales at BillingDate = CALCULATE(sum(SalesOrderPayments[TOTALNETAMOUNT]),USERELATIONSHIP('Date'[Date],SalesOrderPayments[BILLINGDOCUMENTDATE]))
```
```
Payment at Actual Date = CALCULATE(sum('SalesOrderPayments'[U##Payments.PaymentValue]), USERELATIONSHIP('Date'[Date],SalesOrderPayments[U##Payments.PaymentDate]))
```
```
Payment at pred Date = CALCULATE(sum('SalesOrderPayments'[U##Payments.PaymentValue]), USERELATIONSHIP('Date'[Date], SalesOrderPayments[predPaymentDate]))
```

### Create Sales and Payment Forecast report

* Select a `Clustered' Column Chart`
* Use the `Date.Date` hierarchy as X-axis
* Use `Date.Sales at Billing Date`as Y-axis
* Use `Date.Payment at pred Date` as Y-axis
* Use `Date.Payment at actual Date`as Y-axis if you want to compare prediction and actual

    <img src="images/aml/SalesPaymentForecast.jpg" height=600>

In this picture you can judge how well our 'forecasted' payment values are compared to the past actual payment values.

Continue with the [next](CreateAlertingRule.md) step.
