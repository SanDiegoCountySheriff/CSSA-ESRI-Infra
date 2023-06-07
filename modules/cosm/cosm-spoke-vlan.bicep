
param namePrefix string = 'cosm'
param virtualNetworkName string
param virtualNetworkLocation string
param virtualNetworkAddressPrefixes array
param virtualNetworkHubName string

resource virtualNetworkHub 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkHubName
}

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: '${namePrefix}-${virtualNetworkName}-shared-vlan'
  location: virtualNetworkLocation
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    virtualNetworkPeerings: [
      {
        name: 'to_${virtualNetworkHub.name}'
        properties: {
          allowForwardedTraffic: false
          allowGatewayTransit: false
          allowVirtualNetworkAccess: true
          useRemoteGateways: false
          remoteVirtualNetwork: {
            id: virtualNetworkHub.id
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource peerToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: virtualNetworkHub
  name: 'to_${virtualNetworkSpoke.name}'
  properties: {
    allowForwardedTraffic: false
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: virtualNetworkSpoke.id
    }
  }
}

output name string = virtualNetworkSpoke.name
output addressSpace object = virtualNetworkSpoke.properties.addressSpace
output id string = virtualNetworkSpoke.id
