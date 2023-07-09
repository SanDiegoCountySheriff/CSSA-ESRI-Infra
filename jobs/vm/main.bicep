@description('Location for all resources.')
param resourceLocation string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'prd'
  'stg'
  'ist'
  'uat'
  'dev'
])
param environmentType string

param resourceAgency string = 'cosm'

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

var workstationVirtualMachineName   = 'vm-gis-${environmentType}-01'
var portalVirtualMachineName        = 'vm-gis-${environmentType}-02'
var hostingVirtualMachineName       = 'vm-gis-${environmentType}-03'
var notebookVirtualMachineName      = 'vm-gis-${environmentType}-04'
var datastoreVirtualMachineName     = 'vm-gis-${environmentType}-05'

@description('Deploy Proximity Placement Group')
module gisProximityPlacementGroup '../../modules/gis/gis-ppg.bicep' = {
  name: 'deploy_gis-ppg'
  params: {
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
  }
}

module gisAvailabilitySet '../../modules/gis/gis-avail.bicep' = {
  name: 'deploy_gis-avail'
  params: {
    resourceAgency: resourceAgency
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
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: workstationVirtualMachineName
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id:applicationSecurityGroup_workstation.id
      }  
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilitySet.outputs.name
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
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: notebookVirtualMachineName
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    secureBoot: true
    availabilitySetName: gisAvailabilitySet.outputs.name
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
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: portalVirtualMachineName
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilitySet.outputs.name
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
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: hostingVirtualMachineName
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilitySet.outputs.name
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
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualMachineName: datastoreVirtualMachineName
    proximityPlacementGroupName: gisProximityPlacementGroup.outputs.name
    virtualNetworkName: virtualNetworkSpoke.name
    appSecurityGroups: [
      {
        id: applicationSecurityGroups_arcgis.id
      } 
    ]
    virtualMachineSize: virtualMachineSize
    availabilitySetName: gisAvailabilitySet.outputs.name
    adminUsername: adminUsername
    adminPassword: adminPassword   
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
  }
}
