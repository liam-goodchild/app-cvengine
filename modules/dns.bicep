param zoneName string
param subdomain string
param target string

resource zone 'Microsoft.Network/dnsZones@2023-07-01-preview' existing = {
  name: zoneName
}

resource cname 'Microsoft.Network/dnsZones/CNAME@2023-07-01-preview' = {
  name: subdomain
  parent: zone
  properties: {
    TTL: 3600
    CNAMERecord: { cname: target }
  }
}
