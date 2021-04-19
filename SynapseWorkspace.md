# Configure Synapse Workspace

## Introduction
In this part we'll configure the Synapse Workspace and install the Ingration Runtime on our Azure Virtual Machine. If you didn't install the Synapse workspace with the Terraform script (included by default) earlier you can deploy the Synapse Workspace following [these](DeploySynapseWorkspace.md) steps.

# Synapse Configuration
## Setup Firewall
In the Synapse workspace go to `Firewalls` and check if the rules are properly set, this means that all the IP addresses are allowed. If not, choose `+ Add client IP`. Choose `Save` to save the configuration. This is required to setup the linked services in the later steps.

## Register Integration Runtime
The rest of the configuration is done via `Synapse Studio`:\
<img src="images/synapsews/openSynapseStudio.jpg">

To register the integration runtime click on manage:

<img src="images/irt/syn-irt1.png" height = 300>

* Click on `Integration runtimes`:
<img src="images/irt/syn-irt2.png">

* Click on `+ New`:
<img src="images/irt/syn-irt3.png">

* Choose `Self-Hosted`:
<img src="images/irt/syn-irt4.png" height = 400>

* Choose a name for the runtime installation:
<img src="images/irt/syn-irt5.png" height = 400>

* You will receive two key values. Make sure to note these down, in the next step you need one of these keys\
<img src="images/irt/syn-irt6.png" height=400>

* In `Option 2: Manual setup` you can download the integration runtime via `Step 1`. Donwload the installation file and upload it to your VM.

* Login on the Gateway VM and copy the integration runtime MSI package to the download folder, or any other folder you prefer.
Execute the MSI package and press `next` until you get the question for the `authentication key`:
<img src="images/irt/gw-irt1.png" height=400>

* Enter one of the keys you noted down earlier from integration runtime setup and choose `Register`.

* Enter the name of the integration runtime node configured earlier
<img src="images/irt/gw-irt2.png" height=400>

* Choose `Finish`
<img src="images/irt/gw-irt3.png" height=400>

The installation is done and the node is connected and can be used.
You can now proceed with the [next](DataFlowConfig.md) step.
