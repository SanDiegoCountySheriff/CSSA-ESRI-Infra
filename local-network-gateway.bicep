param localNetworkGatewayName string
param localNetworkGatewayLocation string
param localNetworkGatewayAddressPrefixes array
param localNetworkGatewayIpAddress string

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' = {
  name: localNetworkGatewayName
  location: localNetworkGatewayLocation
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localNetworkGatewayAddressPrefixes
  }
  gatewayIpAddress: localNetworkGatewayIpAddress
  }
}

output name string = localNetworkGatewayName
output id string = localNetworkGateway.id
