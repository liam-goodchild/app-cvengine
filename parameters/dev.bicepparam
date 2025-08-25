using '../main.bicep'

param project = 'cvengine'
param environment = 'dev'
param dnsZone = 'skyhaven.ltd'
param dnsZoneResourceGroup = 'rg-gatekeeper-prod-uks-001'
param subdomain = 'portfolio.dev'
param fqdn = 'portfolio.dev.skyhaven.ltd'
param branch = 'dev'
