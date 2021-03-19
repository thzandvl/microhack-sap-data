OBJECT_ID=$(az ad signed-in-user show --query objectId --out tsv)
sed -i s/00000000-0000-0000-0000-000000000000/$OBJECT_ID/g variables.tf