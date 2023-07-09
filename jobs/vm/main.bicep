@description('Location for all resources.')
param resourceLocation string = resourceGroup().location

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

param virtualMachineSize string = 'Standard_D2s_v4'

param adminUsername string = 'gisadmin'
@secure()
param adminPassword string

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkSpokeName
}

resource applicationSecurityGroup_workstation 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: 'asg-gis-ws-${environmentType}-${resourceNameSuffix}'
}

resource applicationSecurityGroups_arcgis 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: 'asg-gis-arcgis-${environmentType}-${resourceNameSuffix}'
}


@description('Deploy Proximity Placement Group')
module gisProximityPlacementGroup '../../modules/gis/gis-ppg.bicep' = {
  name: 'deploy_gis-ppg'
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
  }
}

module gisAvailabilityGroup '../../modules/gis/gis-avail.bicep' = {
  name: 'deploy_gis-avail'
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    availabilitySetPlatformFaultDomainCount: 2
    availabilitySetPlatformUpdateDomainCount: 5
    proximityPlacementGroupId: gisProximityPlacementGroup.outputs.id
  }
}

module gisWorkstationVm '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisWorkstationVm'
  dependsOn: [
    gisProximityPlacementGroup
    applicationSecurityGroups_arcgis
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-ws'
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id:applicationSecurityGroup_workstation.id
      }  
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilityGroup.name
    adminUsername: adminUsername
    adminPassword: adminPassword  
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisNotebookVM')
module gisNotebookVm '../../modules/gis/gis-vm-linux.bicep' = {
  name: 'deploy_gisNotebookVM'
  dependsOn: [
    gisProximityPlacementGroup
    applicationSecurityGroups_arcgis
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-notebook'
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    secureBoot: true
    availabilitySetName: gisAvailabilityGroup.name
    adminUsername: adminUsername
    adminPassword: adminPassword   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisPortalVM')
module gisPortalVm '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisPortalVM'
  dependsOn: [
    gisProximityPlacementGroup
    applicationSecurityGroups_arcgis
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-portal'
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilityGroup.name
    adminUsername: adminUsername
    adminPassword: adminPassword 
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisHostingServerVM')
module gisHostingServerVM '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisHostingServerVM'
  dependsOn: [
    gisProximityPlacementGroup
    applicationSecurityGroups_arcgis
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-hosting'
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilityGroup.name
    adminUsername: adminUsername
    adminPassword: adminPassword  
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}

@description('Deploy gisDatastoreServerVM')
module gisDatastoreServerVM '../../modules/gis/gis-vm-windows.bicep' = {
  name: 'deploy_gisDatastoreServerVM'
  dependsOn: [
    gisProximityPlacementGroup
    applicationSecurityGroups_arcgis
    virtualNetworkSpoke
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: 'cosm-gis-${environmentType}-datastore'
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilityGroup.name
    adminUsername: adminUsername
    adminPassword: adminPassword   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}
