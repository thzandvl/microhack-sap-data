# Synapse Workspace

## Introduction
In this part we'll create the Synapse Workspace and install the Ingration Runtion on our Azure Virtual Machine.

## Creation
* Create a Synapse Analytics Workspace\
<img src="images/synapsews/synapsewsservice.jpg">

Enter the following settings :
### Basics :
* Resource Group
* Workspace Name
* Data Lake Storage : Select an existing Data Lake or create a new one
* File System Name : Select an exising File System or create a new one

<img src="images/synapsews/synapsewsservice_basics.jpg">

### Security :
* Admin Username & Password : this will be there userId and password for the related SQL Pools.

<img src="images/synapsews/synapsewsservice_security.jpg">

Other settings can remain as default.

# After deployment :
* Create a `staging` directory within the Synapse Azure Data Lake container. This directory is used for storage of temporary files during data upload to Synapse.

<img src="images/synapsews/stagingDirectory.jpg">

* Create a new SQL Pool\
Choose `DW100c` as performance level (to save on costs).

<img src="images/synapsews/createSQLPool.jpg">

# Synapse Configuration
The configuration is done via `Synapse Studio`:\
<img src="images/synapsews/openSynapseStudio.jpg">

## Register Integration Runtime
To register the integration runtime click on manage:

<img src="images/irt/syn-irt1.png" height = 300>

* Click on `Integration runtimes`:\
<img src="images/irt/syn-irt2.png">

* Click on `+ New`:\
<img src="images/irt/syn-irt3.png">

* Choose `Self-Hosted`:\
<img src="images/irt/syn-irt4.png" height = 400>

* Choose a name for the runtime installation:\
<img src="images/irt/syn-irt5.png" height = 400>

* You will receive two key values. Make sure to note these down, in the next step you need one of these keys\
<img src="images/irt/syn-irt6.png" height=400>

* In `Option 2: Manual setup` you can download the integration runtime via `Step 1`. Donwload the installation file and upload it to your VM.

* Login on the Gateway VM and copy the integration runtime MSI package to the download folder, or any other folder you prefer.
Execute the MSI package and press `next` until you get the question for the `authentication key`:\
<img src="images/irt/gw-irt1.png" height=400>

* Enter one of the keys you noted down earlier from integration runtime setup and choose `Register`.

* Enter the name of the integration runtime node configured earlier\
<img src="images/irt/gw-irt2.png" height=400>

* Choose `Finish`\
<img src="images/irt/gw-irt3.png" height=400>

The installation is done and the node is connected and can be used.
You can now proceed with the next step.