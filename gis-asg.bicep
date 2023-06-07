
@description('Location for all resources.') 
param location string = resourceGroup().location

param globalAgencyName string = 'cosm'
param globalApplicationName string = 'gis'
param globalPrefix string = '${globalAgencyName}-${globalApplicationName}'

param applicationSecurityGroups_cosm_gis_ws_asg_name string = '${globalPrefix}-ws-asg'
param applicationSecurityGroups_cosm_gis_app_asg_name string = '${globalPrefix}-vm-asg'

resource applicationSecurityGroups_cosm_gis_ws_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: applicationSecurityGroups_cosm_gis_ws_asg_name
  location: location
  tags: {
    app: globalApplicationName
    tier: 'workstation'
    env: ''
    resource: 'asg'
  }
  properties: {}
}

resource applicationSecurityGroups_cosm_gis_app_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: applicationSecurityGroups_cosm_gis_app_asg_name
  location: location
  tags: {
    app: globalApplicationName
    tier: 'application'
    env: ''
    resource: 'asg'
  }
  properties: {}
}
