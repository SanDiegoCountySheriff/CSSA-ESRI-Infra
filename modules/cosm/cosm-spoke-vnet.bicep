
param resourceAgency string = 'cosm'
param resourceType string = 'vnet'
param resourceScope string
param resourceEnv string
param resourceLocation string
param resourceNumber string = '001'

param namePrefix string = '${resourceType}-${resourceAgency}'
param nameSuffix string = '${resourceEnv}-${resourceNumber}'

param virtualNetworkAddressPrefixes array
param virtualNetworkHubName string

resource virtualNetworkHub 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkHubName
}

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: '${namePrefix}-${resourceScope}-${nameSuffix}'
  location: resourceLocation
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    enableDdosProtection: false
  }
}

resource peerSpokeToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: virtualNetworkSpoke
  name: 'to_${virtualNetworkHub.name}'
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: false
    allowVirtualNetworkAccess: true
    useRemoteGateways: true
    remoteVirtualNetwork: {
      id: virtualNetworkHub.id
    }
  }
}
/*
resource peerHubToSpoke 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  parent: virtualNetworkHub
  name: 'to_${virtualNetworkSpoke.name}'
  properties: {
    allowForwardedTraffic: false
    allowGatewayTransit: true
    allowVirtualNetworkAccess: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: virtualNetworkSpoke.id
    }
  }
}
*/
output name string = virtualNetworkSpoke.name
output addressSpace object = virtualNetworkSpoke.properties.addressSpace
output id string = virtualNetworkSpoke.id
