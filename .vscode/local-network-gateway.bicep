param localNetworkGateways_cosm_local_network_gateway_name string = 'cosm-local-network-gateway'

resource localNetworkGateways_cosm_local_network_gateway_name_resource 'Microsoft.Network/localNetworkGateways@2022-11-01' = {
  name: localNetworkGateways_cosm_local_network_gateway_name
  location: 'westus'
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/8'
        '172.31.253.0/24'
      ]
    }
    gatewayIpAddress: '209.76.14.250'
  }
}