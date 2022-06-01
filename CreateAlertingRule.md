# 5 - Create Alerting Rule

[< 4 Integrate ML and PowerBI](./IntegrateMLPowerBI.md) - **[🏠Home](./README.md)** - [ 6 Take Actions in the SAP system >](./UpdateInformationInSap.md)

In this section we'll publish the Power BI Desktop report to Power BI Service, create an alert and use this to trigger a Power Automate flow.

We will be using a Power BI and Power Automate subscription. Please make sure that you sign-up to Power Platform, or even better to the [Microsoft 365 Developer Program](https://developer.microsoft.com/microsoft-365/dev-program) for this.

## Publish Power BI Report

From your Power BI Desktop report Click on `File` -> `Save` to save the document
* Then From `Start` click on `Publish` to publish the document to Power BI Service 
>Note: You might need to sign-on with your Office 365 users that has access to the Power BI service
* In the dialog screen select your target `My Workspace` and click on `Select`
<img src="images/PowerAutomate/publishPowerBI.jpg" >

* Once the report is published, click on `open in Power BI`
<img src="images/PowerAutomate/publishingDone.jpg" >

* As a result you should now see your Power BI report in the Power BI Service in the browser
<img src="images/PowerAutomate/PowerBiService.jpg" >


## Create a new Gauge chart

* From the top row, select `Edit` to add a new element to the report screen

* In the Visualization section select the `Gauge` element and add this to your report
<img src="images/PowerAutomate/SelectGauge.jpg" >

* From the `SalesOrderPayments` table Add the `predOffset` as the `Value` for the Gauge
<img src="images/PowerAutomate/AddOffset.jpg" >

* Change the value from `Sum` to `Maximum`. This will allow us to see the maximum number of offset between payment date and payment received. 
<img src="images/PowerAutomate/OffsetMaximum.jpg" >

* Now go back to the `Reading View` to see the results of the dashboard. If prompted, `Save` the Dashboard. 
<img src="images/PowerAutomate/ReadingView.jpg" >

## Pin Gauge to Dashboard

In order to highlight the Gauge chart and also enable the Alerting, `pin` the Gauge element to a new Dashboard.
* Click on the `Pin` icon of the Gauge visual 
<img src="images/PowerAutomate/PinVisual.jpg" >

* Select `New Dashboard`, enter a Dashboard name, e.g. `My Alerting Dashboard` and click on `Pin`
<img src="images/PowerAutomate/PinToDashboard.jpg" >

* Select `Go to Dashboard` to open the newly created Dashboard
<img src="images/PowerAutomate/GoToDashboard.jpg" >

## Manage Alerts

On the new Dashboard you can see the Gauge visual
* Click on the three dots and select `Manage Alerts`
<img src="images/PowerAutomate/ManageAlerts.jpg" >

 * On the right side click on `Add Alert Rule`
<img src="images/PowerAutomate/AddAlertRule.jpg" >

* Change the `Threshold` to a lower number than the one currently shown in the gauge and select the `Maximum notification frequency` as `At most once an hour`.  This will make sure that the Alert is triggered right away
<img src="images/PowerAutomate/AlertRuleCondition.jpg" >

## Add a Power Automate Flow

In order to get more sophisticated notifications, you can trigger a Power Automate flow directly fro this Alert rule. For this open up the Alert condition again, by clicking on the three dots from the Gauge visual and select `Manage Alert`
* From the `Manage Alert` screen, click on `Use Microsoft Power Automate to trigger additional actions`
<img src="images/PowerAutomate/SelectPATrigger.jpg" >

Now Power Automate will open up. Power Automate allows you to create workflows that can use hundreds of connectors to connect to other systems. In our case we will use a simple Email action to send an email with the alert notification to a user. 
* If required `Sign-In` and click on `Continue`
<img src="images/PowerAutomate/SignInContinue.jpg" >

* In the Power Automate Select the `Max of predOffset` Alert ID in the first step of the flow
<img src="images/PowerAutomate/SelectAlertId.jpg" >

* Then click on `+ New Step` to create a new step in the flow  
<img src="images/PowerAutomate/AddNewStep.jpg" >

* Search for `Send Email` and select `Send an Email (V2)`
<img src="images/PowerAutomate/SelectSendEmailAction.jpg" >

* Enter the Email-Address
<img src="images/PowerAutomate/EnterEmail.jpg" >

* Click on the `Subject` line and select the Dynamic Content `Alert Title`
<img src="images/PowerAutomate/Subject.jpg" >

* In the `Body` field add the `Title URL` 
<img src="images/PowerAutomate/BodyTitleURL.jpg" >

* Click on `Save` to save the Power Automate flow. 
<img src="images/PowerAutomate/SaveFlow.jpg" >

* The next time the alert is triggered, the Power Automate Flow will be activated and an email will be sent with a link to the Power BI Dashboard
<img src="images/PowerAutomate/EmailNotification.jpg" >

>Note: You might want to go back to the Dashboard and change the threshold of the Gauge alert. This should again trigger the alert.

Continue with the [next](UpdateInformationInSap.md) step.
