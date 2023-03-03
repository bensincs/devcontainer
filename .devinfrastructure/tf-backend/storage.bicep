param storageName string
param containerName string
param location string
param dataContribPrincipalId string

resource tfstate 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  location: location
  name: storageName
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: true
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    encryption: {
      services: {
        blob: {
          keyType: 'Account'
          enabled: true
        }
        file: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
    supportsHttpsTrafficOnly: true
  }
  resource blob 'blobServices' = {
    name: 'default'
    properties: {
      deleteRetentionPolicy: {
        enabled: false
      }
      isVersioningEnabled: false
      changeFeed: {
        enabled: false
      }
      restorePolicy: {
        enabled: false
      }
      containerDeleteRetentionPolicy: {
        enabled: false
      }
    }

    resource tfstateContainer 'containers' = {
      name: containerName
      properties: {
        publicAccess: 'None'
      }
    }
  }
}

resource StorageBlobDataContributor 'Microsoft.Authorization/roleDefinitions@2015-07-01' existing = {
  name: 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'
  scope: subscription()
}

// Give a service principal access to manage the blob data.
resource dataContrib 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(tfstate.id, dataContribPrincipalId, StorageBlobDataContributor.id)
  properties: {
    roleDefinitionId: StorageBlobDataContributor.id
    principalId: dataContribPrincipalId
  }
  scope: tfstate
}
