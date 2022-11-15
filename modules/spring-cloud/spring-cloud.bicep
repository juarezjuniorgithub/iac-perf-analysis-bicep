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

@description('Env variables')
param environmentVariables object

@description('Resource tagging')
param resourceTags object

var springCloudSkuName = 'B0'
var springCloudSkuTier = 'Basic'

resource springCloudService 'Microsoft.AppPlatform/Spring@2020-07-01' = {
  name: 'asc-${applicationName}-${environment}'
  location: location
  tags: resourceTags
  sku: {
    name: springCloudSkuName
    tier: springCloudSkuTier
  }
}

resource springCloudApp 'Microsoft.AppPlatform/Spring/apps@2021-06-01-preview' = {
  name: 'app-${applicationName}-${environment}-${instanceNumber}'
  parent: springCloudService
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    public: true
  }
}

resource springCloudAppDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2021-06-01-preview' = {
  name: 'default'
  parent: springCloudApp
  sku: {
    capacity: 1
    name: springCloudSkuName
    tier: springCloudSkuTier
  }
  properties: {
    source: {
      type: 'Jar'
      relativePath: '<default>'
    }
    deploymentSettings: {
      resourceRequests: {
        cpu: '1'
        memory: '1Gi'
      }
      runtimeVersion: 'Java_11'
      environmentVariables: environmentVariables
    }
  }
}

output application_hostname string = springCloudApp.properties.fqdn
