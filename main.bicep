param zoneName string = 'skyhaven.ltd'
param zoneRg string   = 'rg-dnsforge-prod-uks-001'
param zoneSubId string = subscription().subscriptionId
param subdomain string = 'portfolio'
param project string
param environment string
param location string = resourceGroup().location
var locationShort = locationShortCodes[location]
var locationShortCodes = {
  uksouth: 'uks'
}

resource cosmosInstance 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' = {
  name: 'cosmos-${project}-${environment}-${locationShort}-002'
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
  name: 'stapp-${project}-${environment}-${locationShort}-002'
  location: 'West Europe'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/liam-goodchild/app-cvengine'
    branch: 'dev'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource staticWebAppDomain 'Microsoft.Web/staticSites/customDomains@2024-11-01' = {
  parent: staticWebApp
  name: 'portfolio.skyhaven.ltd'
  properties: {
    validationMethod: 'cname-delegation'
  }
  dependsOn: [
    dns
  ]
}

module dns 'modules/dns.bicep' = {
  name: 'dns-records'
  scope: resourceGroup(zoneSubId, zoneRg)
  params: {
    zoneName: zoneName
    subdomain: subdomain
    target: staticWebApp.properties.defaultHostname
  }
}
