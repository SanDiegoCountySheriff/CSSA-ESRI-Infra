
param resourceAgency string = 'cosm'
param resourceType string = 'pip'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param publicIpAddress string

resource publicIPAddresses 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: publicIpAddress
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

output id string = publicIPAddresses.id
output name string = publicIPAddresses.name
