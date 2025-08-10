param accountName string
param dbRegion string
param databaseName string
param containerName string

resource account 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: toLower(accountName)
  location: dbRegion
  properties: {
    enableFreeTier: true
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: dbRegion
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' = {
  parent: account
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
    options: {
      throughput: 1000
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-11-15' = {
  parent: database
  name: containerName
  properties: {
    resource: {
      id: containerName
      partitionKey: {
        paths: [
          '/visitorCount'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/_etag/?'
          }
        ]
      }
    }
  }
}

param planName string
param region string
param functionName string

resource functionPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: planName
  location: region
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {
    reserved: true
  }
}

// Reference the existing storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: 'stresumeproduks001'
}

// Reference the existing Cosmos DB account
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' existing = {
  name: 'cosmosdb-resume-prod-uks-001' // Replace with your Cosmos DB account name
}

// Retrieve the storage account keys
var storageAccountKeys = storageAccount.listKeys().keys

// Retrieve the Cosmos DB connection strings
var cosmosDbConnectionString = cosmosDbAccount.listConnectionStrings().connectionStrings[0].connectionString

// Function App definition
resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionName
  location: region
  kind: 'functionapp,linux'
  properties: {
    reserved: true // Required for Linux-based hosting
    serverFarmId: functionPlan.id // Link to the Standard Consumption Plan
    siteConfig: {
      linuxFxVersion: 'python|3.11' // Specify the runtime version for Linux
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKeys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'CosmosDBConnectionString'
          value: cosmosDbConnectionString
        }
      ]
    }
  }
}
