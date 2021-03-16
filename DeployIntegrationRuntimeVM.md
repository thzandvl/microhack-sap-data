# Deploy and Prepare a Virtual Machine to host the Integration Runtime
In this step, we'll deploy a Azure Virtual Machine to host the Integration Runtime needed by the SAP Table Connector of the Azure Synapse Pipeline.
We'll also insall the SAP .net connector to enable RFC Connectivity to the SAP System.

## Deploy
### Basics
In your subscription create a new VM with a very small size, in this example I used the B2s, with Windows Server 2019 Datecenter.

<img src="images/gw/vm-gw-basics.png" height=1000>

### Disks
We don't need any additional disks, but you can change the OS disk type to "Standard HDD" as we don't need any performance.

<img src="images/gw/vm-gw-disks.png" height=700>

### Networking
Choose the Virtual Network you already have in your subscription or create a new Virtual Network if you don't have any. And choose a subnet where your new VM will be part of. Add a new public IP address to make sure you can logon to the system.

<img src="images/gw/vm-gw-networking.png" height=700>

### Create
The steps `Management`, `Advanced` and `Tags` can be skipped and you can directly jump to "Review + Create".

<img src="images/gw/vm-gw-create.png" height=1000>

### Network Security Group
Make sure your Remote Desktop Port (port `3389` is open on your Network Security Group

Logon to the Gateway VM deployed in the earlier steps. Easiest is to download the SAP .Net Connector on your local environment and copy it to the Runtime Integration Server/ VM.

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