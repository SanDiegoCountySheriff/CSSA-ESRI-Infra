param publicIPAddresses_cosm_virtual_gateway_name string = 'cosm-virtual-gateway'

resource publicIPAddresses_cosm_virtual_gateway_name_resource 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIPAddresses_cosm_virtual_gateway_name
  location: 'westus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.237.174.76'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}