targetScope = 'subscription'

param stateResourceGroup string
param stateStorageName string
param stateContainerName string
param dataContribPrincipalId string

param location string = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: stateResourceGroup
  location: location
}

module storage 'storage.bicep' = {
  name: 'stateStorage'
  scope: rg
  params: {
    storageName: stateStorageName
    containerName: stateContainerName
    dataContribPrincipalId: dataContribPrincipalId
    location: location
  }
}
