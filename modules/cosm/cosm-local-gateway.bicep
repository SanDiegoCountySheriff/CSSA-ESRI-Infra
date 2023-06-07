param namePrefix string = 'cosm'
param nameSuffix string = 'lng'

param localNetworkGatewayName string
param localNetworkGatewayLocation string
param localNetworkGatewayAddressPrefixes array
param localNetworkGatewayIpAddress string

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' = {
  name: '${namePrefix}-${localNetworkGatewayName}-${nameSuffix}'
  location: localNetworkGatewayLocation
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: localNetworkGatewayAddressPrefixes
  }
  gatewayIpAddress: localNetworkGatewayIpAddress
  }
}

output name string = localNetworkGateway.name
output id string = localNetworkGateway.id
output gatewayIpAddress string = localNetworkGateway.properties.gatewayIpAddress
