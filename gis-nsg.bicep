

@description('Load variables for all resources.') 
var sharedVariables = loadYamlContent('./shared-variables.yaml')

@description('Location for all resources.') 
param location string = resourceGroup().location
param cosm_gis_ws_nsg_id string = newGuid()

resource gis_ws_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: 'applicationSecurityGroups_cosm_gis_ws_asg_name'
}


param networkSecurityGroups_cosm_gis_ws_nsg_name string = 'cosm-gis-ws-nsg'

resource networkSecurityGroups_cosm_gis_ws_nsg_resource 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_cosm_gis_ws_nsg_name
  location: location
  tags: {
    app: sharedVariables.tags.app
    tier: sharedVariables.tags.tiers.network
    env: sharedVariables.tags.env
    resource: 'nsg'
  }
  properties: {
    flushConnection: true
    securityRules: [
      {
        id: cosm_gis_ws_nsg_id
        name: 'string'
        properties: {
          access: 'Allow'
          description: 'Allow RDP from CoSM LAN'
          destinationAddressPrefix: '172.16.2.0/24'
          destinationAddressPrefixes: [
            'string'
          ]
          destinationApplicationSecurityGroups: [
            gis_ws_asg
          ]
          destinationPortRange: '3389'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'string'
          ]
          sourceApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {}
            }
          ]
          sourcePortRange: 'string'
          sourcePortRanges: [
            'string'
          ]
        }
        type: 'string'
      }
    ]
  }
}
