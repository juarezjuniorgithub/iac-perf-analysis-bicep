@description('App name')
param applicationName string

@description('Target environment (dev, test, prod, integration, staging, etc')
@maxLength(4)
param environment string = 'dev'

@description('Azure region')
param location string

@description('Resource tagging')
param resourceTags object

@description('Instance number')
@maxLength(3)
param instanceNumber string = '001'

var appInsightsResourceName = 'ai-${applicationName}-${environment}-${instanceNumber}'

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsResourceName
  location: location
  tags: resourceTags
  kind: 'web'
  properties: {
  Application_Type: 'java'
  }
}

output appInsightsInstrumentationKey string = appInsights.properties.InstrumentationKey
