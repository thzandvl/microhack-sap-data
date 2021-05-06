## Payment Generation
The payments are generated based on the extracted Sales Order Headers. 

`paymentDate = BillingdocumentDate + PayOffset +/- random(PayOffsetVariance)`.

In our example the Payment Offset and Payment Offset Variance is depending on the CustomerGroup in the Sales Order Header.

A sample Notebook can be found at [Create Payments from csv](scripts/CreatePaymentsFromCSV.ipynb). This sample Notebook reads the SalesOrder Headers from Azure Data Lake and writes the Payments to Azure Data Lake. 

## Payment upload
We used Azure Cosmos DB as container for the Payments. You need to create a Synapse Pipeline to pick up the generated Payments and import them in a Cosmos DB Collection.

You could also use another DB, eg. Azure SQL. In this case you need to define the Sunapse Pipeline appropriatly.
