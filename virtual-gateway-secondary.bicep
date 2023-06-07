param publicIPAddresses_cosm_virtual_gateway_secondary_name string = 'cosm-virtual-gateway-secondary'

resource publicIPAddresses_cosm_virtual_gateway_secondary 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIPAddresses_cosm_virtual_gateway_secondary_name
  location: 'westus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.237.174.132'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}
