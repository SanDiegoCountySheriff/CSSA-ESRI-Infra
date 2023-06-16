
param virtualNetworkHubName string
param virtualNetworkSpokeName string

param spokeAllowForwardedTraffic bool = false
param spokeAllowGatewayTransit bool = false
param spokeAllowVirtualNetworkAccess bool = false
param spokeUseRemoteGateways bool = false

param hubAllowForwardedTraffic bool = false
param hubAllowGatewayTransit bool = false
param hubAllowVirtualNetworkAccess bool = false
param hubUseRemoteGateways bool = false

resource virtualNetworkHub 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkHubName
}

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkSpokeName
}

resource peerSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: virtualNetworkSpoke
  name: 'to_${virtualNetworkHub.name}'
  properties: {
    allowForwardedTraffic: spokeAllowForwardedTraffic
    allowGatewayTransit: spokeAllowGatewayTransit
    allowVirtualNetworkAccess: spokeAllowVirtualNetworkAccess
    useRemoteGateways: spokeUseRemoteGateways
    remoteVirtualNetwork: {
      id: virtualNetworkHub.id
    }
  }
}

resource peerHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: virtualNetworkHub
  name: 'to_${virtualNetworkSpoke.name}'
  properties: {
    allowForwardedTraffic: hubAllowForwardedTraffic
    allowGatewayTransit: hubAllowGatewayTransit
    allowVirtualNetworkAccess: hubAllowVirtualNetworkAccess
    useRemoteGateways: hubUseRemoteGateways
    remoteVirtualNetwork: {
      id: virtualNetworkSpoke.id
    }
  }
}
