## Prepare the Gateway server
Make sure port 3389 is open on your Network Security Gateway and logon to the system. Two components need to be installed to activate the system as a gateway system for the SAP connection:

1. The SAP table connector. More information can be found [here](https://docs.microsoft.com/en-us/azure/data-factory/connector-sap-table). And you can download the connector [here](https://support.sap.com/en/product/connectors/msnet.html). Make sure to choose the 64-bit connector compiled with .NET Framework 4.0.
2. The on-premises data gateway. More information can be found [here](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install). And you can download the gateway [here](https://www.microsoft.com/en-us/download/details.aspx?id=53127).

Logon to the Gateway VM deployed in the earlier steps. Easiest is to download the table connector and the data gateway on your local environment and copy them to the Gateway VM.

![VM GW downloads](/images/gw/vm-gw-downloads.png)

### Install the SAP Table Connector
Extract the SAP connector and open the folder.

![VM GW connector](/images/gw/vm-gw-connector.png)

Start the executable

![VM GW connector setup 1](/images/gw/vm-gw-connsetup1.png)

Press next until the following screen 

![VM GW connector setup 2](/images/gw/vm-gw-connsetup2.png)

Choose `Install assemblies to GAC`, Next

![VM GW connector setup 3](/images/gw/vm-gw-connsetup3.png)

Again Next and choose Close

The installation of the SAP Table connector is complete, continue to the next step.

### Install the on-premises gateway
Start the GatewayInstall executable. For the installation it is easier to follow the steps as mentioned in [this](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-install#install-data-gateway) link. If you want to change the region you have to do it during the installation, it can be done in the same screen as where you define the recovery key!

### Configure the on-premises data gateway
Next step is to configure the on-premises gateway from the Azure Portal. The instructions can be found [here](https://docs.microsoft.com/en-us/azure/logic-apps/logic-apps-gateway-connection).

1. Create new on-premises gateway

![Portal On-prem gateway 1](/images/gw/portal-on-prem-gw1.png)

Choose add

2. Choose the right parameters

![Portal On-prem gateway 2](/images/gw/portal-on-prem-gw2.png)

Choose the same location as the one defined during your gateway installation on the VM otherwise you cannot select your installation name.

You now successfully prepared the Gateway VM!