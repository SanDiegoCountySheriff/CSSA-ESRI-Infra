

@description('Location for all resources.') 
param location string = resourceGroup().location

var sharedVariables = loadJsonContent('./shared-variables.json')
param applicationSecurityGroups_cosm_gis_ws_asg_name string = 'cosm-gis-ws-asg'
param applicationSecurityGroups_cosm_gis_app_asg_name string = 'cosm-gis-vm-asg'

resource applicationSecurityGroups_cosm_gis_ws_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: applicationSecurityGroups_cosm_gis_ws_asg_name
  location: location
  tags: {
    app: sharedVariables.tags.app
    tier: sharedVariables.tags.tiers.network
    env: sharedVariables.tags.env
    resource: 'asg'
  }
  properties: {}
}

resource applicationSecurityGroups_cosm_gis_app_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: applicationSecurityGroups_cosm_gis_app_asg_name
  location: location
  tags: {
    app: sharedVariables.tags.app
    tier: sharedVariables.tags.tiers.network
    env: sharedVariables.tags.env
    resource: 'asg'
  }
  properties: {}
}
