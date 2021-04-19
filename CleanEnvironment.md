# Remove the Microhack environment with Terraform
Once you are finished with the Microhack environment it is best to remove the environment. You can do this by using Terraform or by removing the Resource Group yourself.

## Destroy the Terraform environment
The easiest way is to go back to the cloud shell and execute the following steps:
1. Login to Azure cloud shell https://shell.azure.com/
2. Check the subscription you are using for the Microhack: \
`az account show` \
If the subscription shown is not the right one change this with: \
`az account set --subscription "YourSubscriptionName"`
3. Change Directory into the terraform folder: \
`cd microhack-sap-data/terraform`
4. Run the Terraform destroy command: \
`terraform destroy`

## Remove the Resource Group
If the Terraform option does not work for you, you can also remove the Resource Group. You can either do this via the `Azure Portal` or via alternative ways which you may know yourself, i.e. CLI or PowerShell.