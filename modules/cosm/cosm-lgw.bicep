param resourceAgency string = 'cosm'
param resourceType string = 'lgw'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param localNetworkGatewayAddressPrefixes array
param localNetworkGatewayIpAddress string

resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
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
