@description('App name')
param applicationName string

@description('Target environment (dev, test, prod, integration, staging, etc')
@maxLength(4)
param environment string = 'dev'

@description('Instance number')
@maxLength(3)
param instanceNumber string = '001'

@description('Azure region')
param location string

@description('Resource tagging')
param resourceTags object

@description('Container name')
param containerName string = applicationName


var storageName = 'st${take(replace(applicationName, '-', ''),14)}${environment}${instanceNumber}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageName
  location: location
  tags: resourceTags
  kind: 'StorageV2'

  sku: {
    name: 'Standard_LRS'
  }
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageAccount.name}/default/${containerName}'
}

output storageAccountName string = storageAccount.name
output id string = storageAccount.id
output apiVersion string = storageAccount.apiVersion
