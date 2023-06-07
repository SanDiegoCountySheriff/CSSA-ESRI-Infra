
param namePrefix string = 'cosm'
param virtualNetworkName string
param virtualNetworkLocation string
param virtualNetworkAddressPrefixes array

resource virtualNetworkHub 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: '${namePrefix}-${virtualNetworkName}-shared-vlan'
  location: virtualNetworkLocation
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    enableDdosProtection: false
  }
}

output name string = virtualNetworkHub.name
output addressSpace object = virtualNetworkHub.properties.addressSpace
output id string = virtualNetworkHub.id
