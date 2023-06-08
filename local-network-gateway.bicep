param localNetworkGatewayName string = 'local-network-gateway'
param localNetworkGatewayLocation string = 'westus'
param localNetworkGatewayAddressPrefixes array = [
  '10.0.0.0/8'
  '172.31.253.0/24'
]
param localNetworkGatewayIpAddress string = '209.76.14.250'

resource localNetworkGatewayResource 'Microsoft.Network/localNetworkGateways@2022-11-01' = {
  name: localNetworkGatewayName
  location: localNetworkGatewayLocation
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localNetworkGatewayAddressPrefixes
  }
  gatewayIpAddress: localNetworkGatewayIpAddress
  }
}
