using '../main.bicep'

param project = 'cvengine'
param environment = 'prod'
param dnsZone = 'skyhaven.ltd'
param dnsZoneResourceGroup = 'rg-gatekeeper-prod-uks-001'
param subdomain = 'portfolio'
param fqdn = 'portfolio.skyhaven.ltd'
param branch = 'prod'
