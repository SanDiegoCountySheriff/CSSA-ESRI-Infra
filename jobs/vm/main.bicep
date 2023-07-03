

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param virtualNetworkSpokeName string

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkSpokeName
}

@description('Deploy Proximity Placement Group')
module gisProximityPlacementGroup_resource '../../modules/gis/gis-ppg.bicep' = {
  name: 'deploy_gis-ppg'
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
  }
}

@description('Deploy gisNotebookVM')
module gisNotebookVm_resource '../../modules/gis/gis-notebook-vm.bicep' = {
  name: 'deploy_gisNotebookVM'
  dependsOn: [
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: ''
    virtualMachineComputerName: ''
    proximityPlacementGroupId: gisProximityPlacementGroup_resource.outputs.id
    virtualNetworkName: virtualNetworkSpoke.name
    virtualMachineSize: ''
    secureBoot: true
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''
    
  }
}
