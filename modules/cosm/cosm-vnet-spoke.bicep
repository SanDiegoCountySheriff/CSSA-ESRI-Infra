
param resourceAgency string = 'cosm'
param resourceType string = 'vnet'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param subnets array = []
param virtualNetworkAddressPrefixes array

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetworkAddressPrefixes
    }
    enableDdosProtection: false
    subnets: subnets
  }
}


output name string = virtualNetworkSpoke.name
output addressSpace object = virtualNetworkSpoke.properties.addressSpace
output id string = virtualNetworkSpoke.id
output subnets array = virtualNetworkSpoke.properties.subnets
