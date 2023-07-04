

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

resource applicationSecurityGroup_Workstation 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: 'asg-gis-ws-${environmentType}-${resourceNameSuffix}'
}

resource applicationSecurityGroups_ArcGIS 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: 'asg-gis-arcgis-${environmentType}-${resourceNameSuffix}'
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
module gisNotebookVm_resource '../../modules/gis/gis-linux-vm.bicep' = {
  name: 'deploy_gisNotebookVM'
  dependsOn: [
    gisProximityPlacementGroup_resource
    applicationSecurityGroups_ArcGIS
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-notebook'
    proximityPlacementGroupName: gisProximityPlacementGroup_resource.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      applicationSecurityGroups_ArcGIS
    ]
    virtualMachineSize: ''
    secureBoot: true
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisPortalVM')
module gisPortalVm_resource '../../modules/gis/gis-windows-vm.bicep' = {
  name: 'deploy_gisPortalkVM'
  dependsOn: [
    gisProximityPlacementGroup_resource
    applicationSecurityGroups_ArcGIS
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-portal'
    proximityPlacementGroupName: gisProximityPlacementGroup_resource.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      applicationSecurityGroups_ArcGIS
    ]
    //virtualMachineSize: ''
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}
