# Deploy and Prepare a Virtual Machine to host the Integration Runtime
In this step, we'll deploy a Azure Virtual Machine to host the Integration Runtime needed by the SAP Table Connector of the Azure Synapse Pipeline.
We'll also install the SAP .net connector to enable RFC Connectivity to the SAP System.

## Deploy Gateway VM with Terraform
To avoid problems we will use Terraform to deploy a new Resource Group, Virtual Network, Subnet and Virtual Machine which will be used as the Gateway server.

To trigger the Terraform deployment, follow the steps below:
1. Login to Azure cloud shell https://shell.azure.com/
2. Check the subscription you will be using for the Microhack: \
`az account show` \
If the subscription shown is not the right one change this with: \
`az account set --subscription "YourSubscriptionName"`
3. Clone the GitHub repository with the Terraform scripts: \
`git clone https://github.com/thzandvl/microhack-sap-data`
4. Change Directory into the terraform folder: \
`cd microhack-sap-data/terraform`
5. Download the AzureRM resource provider: \
`terraform init`
6. Run apply to start the deployment: \
`terraform apply`
7. Choose your prefered username and password for the VM.
8. When prompted choose `yes` to deploy the script.
9. Once the script is finished you will get a public IP address, use this address to login to your new VM.
10. Use `Remote Desktop Connection` to login to the new VM and continue with the next section.


## Prepare

### Install the SAP .Net Connector
The SAP .Net Connector can be downloaded from the SAP Service Marketplace.

* Extract the SAP connector and open the folder\
<img src="images/gw/vm-gw-connector.png" height=300>

* Start the executable\
<img src="images/gw/vm-gw-connsetup1.png" height=300>

* Press `Next` until the following screen\
<img src="images/gw/vm-gw-connsetup2.png" height=300>

* Choose `Install assemblies to GAC`, then `Next`\
<img src="images/gw/vm-gw-connsetup3.png" height=300>

* Again press `Next` and choose `Close`

The installation of the SAP .Net Connector is complete, continue to the next step.