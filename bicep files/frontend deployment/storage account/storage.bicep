param storageName string
param storageRegion string
param storageSKU string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageName
  location: storageRegion
  kind: 'StorageV2'
  sku: {
    name: storageSKU
  }
}
