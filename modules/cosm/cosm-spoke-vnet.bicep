
param resourceAgency string = 'cosm'
param resourceType string = 'vnet'
param resourceScope string
param resourceEnv string
param resourceLocation string
param resourceNumber string = '001'

param namePrefix string = '${resourceType}-${resourceAgency}'
param nameSuffix string = '${resourceEnv}-${resourceNumber}'

param virtualNetworkAddressPrefixes array

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


output name string = virtualNetworkSpoke.name
output addressSpace object = virtualNetworkSpoke.properties.addressSpace
output id string = virtualNetworkSpoke.id
