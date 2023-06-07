
param namePrefix string = 'cosm'
param publicIpAddressName string
param publicIpAddressLocation string
param publicIpAddress string

resource publicIPAddresses 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: '${namePrefix}-${publicIpAddressName}'
  location: publicIpAddressLocation
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
