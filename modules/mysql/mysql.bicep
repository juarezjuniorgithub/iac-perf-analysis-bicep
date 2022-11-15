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
param tags object

@description('MySQL instance')
param serverName string = 'mysql-${applicationName}-${environment}-${instanceNumber}'

@description('MySQL database')
param sqlDBName string = applicationName

@description('MySQL instance admin')
param administratorLogin string = 'sql${substring(replace(applicationName, '-', ''),0,8)}root'

@description('MySQL instance pw')
@secure()
param administratorPassword string = newGuid()

resource sqlServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: serverName
  tags: tags
  location: location
  sku: {
  name: 'B_Gen5_1'
  }
  properties: {
    sslEnforcement: 'Enabled'
    minimalTlsVersion: 'TLS1_2'
    storageProfile: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
      storageAutogrow: 'Enabled'
      storageMB: 5120
    }
    version: '5.7'
    createMode: 'Default'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
  }
}

resource sqlDatabase 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = {
  name: sqlDBName
  parent: sqlServer
  properties: {
    charset: 'UTF8'
  }
}

resource sqlFirewall 'Microsoft.DBforMySQL/servers/firewallRules@2017-12-01' = {
  name: 'AllowAzureServices'
  parent: sqlServer
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output db_url string = sqlServer.properties.fullyQualifiedDomainName
