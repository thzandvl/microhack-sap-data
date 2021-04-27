# MicroHack Setup

This page describes the setup required if you want to run your own MicroHack.

## SAP System
The MicroHack relies on Sales Data, so you'll need an SAP System containing Sales Orders. From technical point of view, we extract Sales Data via a CDS View and via a oData.
The code for the CDS View can be found at [ZBD_ISALESDOC_E CDS View](scripts/zbd_t_salesdocument_e.asddls).
The oData Service used is ´/sap/opu/odata/sap/sd_f1814_so_fs_srv/´.

We would recommend to use a SAP CAL image of a ´SAP S/4HANA Fully-Activated Appliance´.
> Disclaimer : Until now we haven't tested the MicroHack with a SAP CAL system.

## Payment Generation
The payments are generated based on the extracted Sales Order Headers. 

`paymentDate = BillingdocumentDate + PayOffset +/- random(PayOffsetVariance)`.

In our example the Payment Offset and Payment Offset Variance is depending on the CustomerGroup in the Sales Order Header.

A sample Notebook can be found at [Create Payments from csv](scripts/CreatePaymentsFromCSV.ipynb). This sample Notebook reads the SalesOrder Headers from Azure Data Lake and writes the Payments to Azure Data Lake. 

## Payment upload
We used Azure Cosmos DB as container for the Payments. You need to create a Synapse Pipeline to pick up the generated Payments and import them in a Cosmos DB Collection.

You could also use another DB, eg. Azure SQL. In this case you need to define the Sunapse Pipeline appropriatly.





