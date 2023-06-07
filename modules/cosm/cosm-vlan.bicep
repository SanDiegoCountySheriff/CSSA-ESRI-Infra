
param namePrefix string = 'cosm'
param virtualNetworkName string
param virtualNetworkLocation string
param virtualNetworkAddressPrefixes array

resource virtualNetwork_cosm 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: '${namePrefix}-${virtualNetworkName}-vlan'
  location: virtualNetworkLocation
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

output name string = virtualNetwork_cosm.name
output addressSpace object = virtualNetwork_cosm.properties.addressSpace
output id string = virtualNetwork_cosm.id
