## Deploy a gateway server for the SAP RFC connection
### Basics
<p>
In your subscription create a new VM with a very small size, in this example I used the B2s, with Windows Server 2019 Datecenter.
</p>
<img src="images/gw/vm-gw-basics.png" height="700px" />

### Disks
<p>
We don't need any additional disks, but you can change the OS disk type to "Standard HDD" as we don't need any performance.
</p>
<img src="images/gw/vm-gw-disks.png" height="400px" />

### Networking
<p>
Choose the Virtual Network you already have in your subscription or create a new Virtual Network if you don't have any. And choose a subnet where your new VM will be part of. Add a new public IP address to make sure you can logon to the system.
</p>
<img src="images/gw/vm-gw-networking.png" height="500px" />

### Create
<p>
The steps management, advanced and tags can be skipped and you can directly jump to "Review + Create".
</p>
<img src="images/gw/vm-gw-create.png" height="700px" />

Go to the next step to prepare the server: [Prepare the Gateway server](PrepareGateway.md)