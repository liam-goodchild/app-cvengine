param dnsZone string
param dnsZoneResourceGroup string
param fqdn string
param subdomain string
param project string
param environment string
param location string = resourceGroup().location
param branch string
var cosmosKeys = listKeys(cosmosInstance.id, '2023-11-15')
var cosmosEndpoint = 'AccountEndpoint=${cosmosInstance.properties.documentEndpoint};AccountKey=${cosmosKeys.primaryMasterKey};'
var locationShort = locationShortCodes[location]
var locationShortCodes = {
  uksouth: 'uks'
}

resource cosmosInstance 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: 'cosmos-${project}-${environment}-${locationShort}-001'
  location: location
  properties: {
    enableFreeTier: true
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
      }
    ]
  }
}

resource cosmosDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-11-15' = {
  parent: cosmosInstance
  name: 'visitorDatabase'
  properties: {
    resource: {
      id: 'visitorDatabase'
    }
    options: {
      throughput: 1000
    }
  }
}

resource cosmosContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-11-15' = {
  parent: cosmosDatabase
  name: 'visitorContainer'
  properties: {
    resource: {
      id: 'visitorContainer'
      partitionKey: {
        paths: [
          '/id'
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

resource staticWebApp 'Microsoft.Web/staticSites@2024-11-01' = {
  name: 'stapp-${project}-${environment}-${locationShort}-001'
  location: 'West Europe'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/liam-goodchild/app-cvengine'
    branch: branch
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource staticWebAppDomain 'Microsoft.Web/staticSites/customDomains@2024-11-01' = {
  parent: staticWebApp
  name: fqdn
  properties: {
    validationMethod: 'cname-delegation'
  }
  dependsOn: [
    dns
  ]
}

resource staticWebAppCosmosConnection 'Microsoft.Web/staticSites/config@2024-11-01' = {
  name: 'functionappsettings'
  parent: staticWebApp
  properties: {
    CosmosDBConnectionString: cosmosEndpoint
  }
}

module dns 'modules/dns.bicep' = {
  name: 'dns-records'
  scope: resourceGroup(dnsZoneResourceGroup)
  params: {
    zoneName: dnsZone
    subdomain: subdomain
    target: staticWebApp.properties.defaultHostname
  }
}
