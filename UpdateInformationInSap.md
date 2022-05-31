# Take Actions in the SAP system
As a final step we want to take actions with the information that we saw in the Power BI Dashboard. 
Thanks to the ML and alerting functionality we can easily identify payers, whose payment is typically delayed. In order to flag them in the SAP system (we will assign a Business Partner Role 03 - "excluded business partner" to them) we want to add a feature to our Power BI Dashboards that quickly can flag such a customer as a "bad payer" in the SAP system.

For this we have created a simple Power Automate flow that calls the OData service to update the Business Partner role from "Customer" to "Excluded Business Partner".


## Import Power Automate Flow
* Open https://flow.microsoft.com/ and click on `My Flows` -> `Import` to import the preconfigued Power Automate Flow that updates the Business Partner Role
<img src="images/UpdateDataInSAP/MyFlowsImport.jpg"> 

* Click on Upload and select the `UpdateBusinessPartner` ZIP file
<img src="images/UpdateDataInSAP/ImportPackages.jpg"> 

* Click on the `Action` item to add your Power BI User
<img src="images/UpdateDataInSAP/ImportPackage-Action.jpg"> 

* If you do not have a user configured for Power BI, click on `Create new` to add a new connection. Otherwise, just select the existing user and click on `Save`. In this case you can also skip the next steps. 
<img src="images/UpdateDataInSAP/PowerBiConnection-New.jpg"> 


* A new Browser-Tab will open. Click on `+ New Connection` and search for the Power BI Connector and select it
<img src="images/UpdateDataInSAP/SelectPowerBiConnector.jpg"> 

* Select `Create` in the new Power BI windows
<img src="images/UpdateDataInSAP/PowerBi-Create.jpg"> 


* Enter / select the username and password for the connection and click on `Create`
<img src="images/UpdateDataInSAP/SelectPowerBIUser.jpg"> 

* Switch back to the previous screen where you imported the Flow, click on `Refresh`, select the newly created users and click on `Save`
<img src="images/UpdateDataInSAP/RefreshandSave.jpg"> 

* With this you should be able to `Import` the flow in your environment. 
<img src="images/UpdateDataInSAP/Import.jpg"> 


## Activate the Flow
* Go back to `My Flows`and select the UpdateBusinessPartnerRole flow
<img src="images/UpdateDataInSAP/SelectUpdateFlow.jpg"> 

* Click on the three dots and activate the flow by clicking `Turn On`
<img src="images/UpdateDataInSAP/TurnOn.jpg"> 

## Adding Power Automate to Power BI Dashboard
* Now switch back to the Power BI Dashboard and make sure that you are in the Edit Mode
<img src="images/UpdateDataInSAP/EnsureEditMode.jpg"> 

* From the visual pane, select the `Power Automate` visual
<img src="images/UpdateDataInSAP/PAVisual.jpg"> 

* Make sure the Power Automate visual is selected and drag and drop `CUSOMTERNAME` and `predOffset` from the SalesOrderPayments table to the `Power Automate data` field
<img src="images/UpdateDataInSAP/MapFieldsToPA.jpg"> 

* On the Power Automate Visual, click on the three dots and select `Edit`
<img src="images/UpdateDataInSAP/EditPAVisual.jpg"> 

* The Power Automate Screen should open. Wait till the flow page is fully loaded and click on the `Update Business Partner from Power BI` flow
<img src="images/UpdateDataInSAP/ConnectPAFlow.jpg"> 

* Click on Apply to make the Power Automate Flow available in the Power BI Dashboard. Then click on `Back to Report` to return to the Power BI Dashboard
<img src="images/UpdateDataInSAP/ApplyFlow.jpg"> 

## Display slected customers
In order to show which customers are currently selected in the various drill-downs, add a table visual to the dashboard

* Make sure that no other visual is currently selected and click  the table visual 
<img src="images/UpdateDataInSAP/TableVisual.jpg"> 

* Drag and drop the `CUSTOMERNAME` from the SalesOrderPayments table to the `Values` field of the table. 
<img src="images/UpdateDataInSAP/CustomerTable.jpg"> 

## Test the Power Automate Flow
* With this we have everything prepared. Go back to the `Reading View`. 
<img src="images/UpdateDataInSAP/ReadingView.jpg"> 

* Save your changes
<img src="images/UpdateDataInSAP/SaveChanges.jpg"> 

* If you see a screen like this, just click "anywhere" to reset the drill-down
<img src="images/UpdateDataInSAP/NothingDisplayed.jpg"> 

* You can drill-down by selecting the Z2 column in the `Average of Offset by CUSOMTERGROUP` visual. Then from the CUSTOMERNAME table, select any customer. 
<img src="images/UpdateDataInSAP/DrillDown.jpg"> 

* When you now click on the `Run flow` button, the Power Automate flow will get triggered, and the Business Partner Role of the Customer selected will be updated to 03. 
<img src="images/UpdateDataInSAP/CustomerUpdated.jpg"> 









