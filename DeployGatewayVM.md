## Deploy a gateway server for the SAP RFC connection
### Basics
In your subscription create a new VM with a very small size, in this example I used the B2s, with Windows Server 2019 Datecenter.

![VM GW Basics](\images\gw\vm-gw-basics.png)

### Disks
We don't need any additional disks, but you can change the OS disk type to "Standard HDD" as we don't need any performance.

![VM GW Disks](\images\gw\vm-gw-disks.png)

### Networking
Choose the Virtual Network you already have in your subscription or create a new Virtual Network if you don't have any. And choose a subnet where your new VM will be part of. Add a new public IP address to make sure you can logon to the system.

![VM GW Networking](\images\gw\vm-gw-networking.png)

### Create
The steps management, advanced and tags can be skipped and you can directly jump to "Review + Create".

![VM GW Create](\images\gw\vm-gw-create.png)

Go to the next step to prepare the server: [Prepare the Gateway server](PrepareGateway.md)