# Deploying the bicep file to the resource group using the parameters file.
az deployment group create -g "rg-resume-prod-uks-001" -f "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\backend\cosmosdb\cosmosdb.bicep" -p "C:\Users\lgoodchild-a\Documents\Cloud Resume Challenge v2\backend\cosmosdb\cosmosdb-parameters.json"

<# Once the account, database and container are created, manually create a new item and paste in the following content.

{
  "id": "visitorCount",
  "visitorCount": "visitorCount",
  "count": 0
}

#>