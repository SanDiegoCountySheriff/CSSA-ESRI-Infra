

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

param vmSize string = 'Standard_D2s_v4'

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

module gisWorkstationVm '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisWorkstationVm'
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
    virtualMachineName: 'cosm-gis-${environmentType}-ws'
    proximityPlacementGroupName: gisProximityPlacementGroup_resource.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      applicationSecurityGroup_Workstation
    ]
    virtualMachineSize: vmSize
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisNotebookVM')
module gisNotebookVm '../../modules/gis/gis-vm-linux.bicep' = {
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
    virtualMachineSize: vmSize
    secureBoot: true
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisPortalVM')
module gisPortalVm '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisPortalVM'
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
    virtualMachineSize: vmSize
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisHostingServerVM')
module gisHostingServerVM '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisHostingServerVM'
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
    virtualMachineName: 'cosm-gis-${environmentType}-hosting'
    proximityPlacementGroupName: gisProximityPlacementGroup_resource.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      applicationSecurityGroups_ArcGIS
    ]
    virtualMachineSize: vmSize
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisDatastoreServerVM')
module gisDatastoreServerVM '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisDatastoreServerVM'
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
    virtualMachineName: 'cosm-gis-${environmentType}-datastore'
    proximityPlacementGroupName: gisProximityPlacementGroup_resource.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      applicationSecurityGroups_ArcGIS
    ]
    virtualMachineSize: vmSize
    availabilitySetName: ''
    adminUsername: ''
    adminPassword: ''   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}
