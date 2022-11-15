targetScope = 'subscription'

param environment string = 'dev'
param applicationName string = 'lyit-perf-bcp'
param location string = 'westeurope'
var instanceNumber = '001'

var defaultTags = {
  environment: environment
  application: applicationName
  'nubesgen-version': '0.13.0'
}

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${applicationName}-${instanceNumber}'
  location: location
  tags: defaultTags
}

module instrumentation 'modules/application-insights/app-insights.bicep' = {
  name: 'instrumentation'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    instanceNumber: instanceNumber
    resourceTags: defaultTags
  }
}

module blobStorage 'modules/storage-blob/storage.bicep' = {
  name: 'storage'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    resourceTags: defaultTags
    instanceNumber: instanceNumber
  }
}

module sqlDb 'modules/mysql/mysql.bicep' = {
  name: 'sqldatabase'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    tags: defaultTags
    instanceNumber: instanceNumber
  }
}

var applicationEnvironmentVariables = {
      APPINSIGHTS_INSTRUMENTATIONKEY: instrumentation.outputs.appInsightsInstrumentationKey
      azure_storage_account_name: blobStorage.outputs.storageAccountName      
}
module springCloudApp 'modules/spring-cloud/spring-cloud.bicep' = {
  name: 'springCloudApp'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    applicationName: applicationName
    environment: environment
    resourceTags: defaultTags
    instanceNumber: instanceNumber
    environmentVariables: applicationEnvironmentVariables
  }
}
