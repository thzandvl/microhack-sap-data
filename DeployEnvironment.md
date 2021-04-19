# Deploy the Microhack environment with Terraform
To avoid problems we will use Terraform to deploy a new Resource Group, Virtual Network, Subnet and Virtual Machine which will be used as the Gateway server. You can also deploy the Synapse workspace if preferred. If you don't want to deploy the Synapse workspace with Terraform you have to rename or remove the file `Synapse.tf`.

To trigger the Terraform deployment, follow the steps below:
1. Login to Azure cloud shell https://shell.azure.com/
2. Check the subscription you will be using for the Microhack: \
`az account show` \
<img src="images/gw/deployTF1.jpg" height=300> \
If the subscription shown is not the right one change this with: \
`az account set --subscription "YourSubscriptionName"`
3. Clone the GitHub repository with the Terraform scripts: \
`git clone https://github.com/thzandvl/microhack-sap-data`
<img src="images/gw/deployTF2.jpg" height=150>
4. Change Directory into the terraform folder: \
`cd microhack-sap-data/terraform`
<img src="images/gw/deployTF3.jpg" height=170>
Check the `variables.tf` file by using the command `cat variables.tf` as shown in the screenshot, you should see an entry `object_id` with only zeroes as value:
<img src="images/gw/deployTF4.jpg" height=100>
We will update this values by running the script in the next step.
5. Run `sh setObjectID.sh`, this will set the Principle ID of your user in the file `variables.tf` as it cannot be retrieved in the Azure cloud shell.
<img src="images/gw/deployTF5.jpg" height=150>
6. Check the default values defined in `variables.tf` and change them if required. You can do this again with `cat variables.tf` as shown in the screenshot above
<img src="images/gw/deployTF6.jpg" height=300>
 Make sure that the `object_id` is set and not only shows zeroes. Remember the username and password which you will need to login to the Gateway VM once deployed and these credentials will also be used for the Synapse workspace.
7. Download the AzureRM resource provider:
`terraform init`
<img src="images/gw/deployTF7.jpg" height=400>
8. Run apply to start the deployment, and choose `yes` once prompted to deploy the script:
`terraform apply`
<img src="images/gw/deployTF8.jpg" height=150>
...
<img src="images/gw/deployTF9.jpg" height=150>
9. Once the script is finished you will get a public IP address, this is the public IP address of the Gateway VM just deployed.
<img src="images/gw/deployTF10.jpg" height=100>
10. Use `Remote Desktop Connection` to login to the new VM and continue with the next section.
<img src="images/gw/vm-gw1.jpg" height=200>
Enter the IP address shown at the end of the Terraform script
<img src="images/gw/vm-gw2.jpg" height=200>


## Prepare
In this step, we'll prepare an Azure Virtual Machine to host the Integration Runtime needed by the SAP Table Connector of the Azure Synapse Pipeline.
We'll also install the SAP .net connector to enable RFC Connectivity to the SAP System.

### Install the SAP .Net Connector
The downloads can best be done directly to the Gateway VM. The VM uses Internet Explorer by default which demands you to make all the websites trusted one by one. Easiest is to turn off the `IE Enhanced Security Configuration` setting in the `Server Manager` for `Local Server`. Click on `On` marked in the red square as shown in the screenshot.
<img src="images/gw/vm-gw3.jpg">
Turn off the security for Administrators and Users: \
<img src="images/gw/vm-gw4.jpg" height=300> \
Open `Internet Explorer` on the GW VM and use the recommended settings. The SAP .Net Connector can be downloaded from the [SAP Service Marketplace](https://support.sap.com/en/product/connectors/msnet.html). Make sure to download the version compiled with .Net Framework 4.0 for Windows 64-bit.

* Extract the SAP connector and open the folder 
<img src="images/gw/vm-gw-connector.png" height=300>

* Start the executable .If you get the `Windows protected` screen choose `More info` and `Run anyway`
<img src="images/gw/vm-gw5.jpg" height=300> \
<img src="images/gw/vm-gw-connsetup1.png" height=300>

* Press `Next` until the following screen 
<img src="images/gw/vm-gw-connsetup2.png" height=300>

* Choose `Install assemblies to GAC` \
<img src="images/gw/vm-gw6.jpg" height=300>
 
 * Finally press `Next` 
<img src="images/gw/vm-gw-connsetup3.png" height=300>

* Again press `Next` and choose `Close`

The installation of the SAP .Net Connector is complete, continue to the [next](SynapseWorkspace.md) step.
