

param networkSecurityGroups_cosm_gis_ws_nsg_name string = 'cosm-gis-ws-nsg'

resource symbolicname 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_cosm_gis_ws_nsg_name
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  properties: {
    flushConnection: true
    securityRules: [
      {
        id: 'string'
        name: 'string'
        properties: {
          access: 'Allow'
          description: 'Allow RDP from CoSM LAN'
          destinationAddressPrefix: '172.16.2.0/24'
          /*
          destinationAddressPrefixes: [
            'string'
          ]*/
          destinationApplicationSecurityGroups: [
            {
              id: 'string'
              location: 'string'
              properties: {}
              tags: {}
            }
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
