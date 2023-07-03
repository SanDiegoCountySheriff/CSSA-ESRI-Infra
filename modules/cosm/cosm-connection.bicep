
param resourceAgency string = 'cosm'
param resourceType string = 'con'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param localNetworkGatewayName string
param virtualNetworkGatewayName string

@secure()
param sharedKey string


resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGatewayName
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' existing = {
  name: virtualNetworkGatewayName
}

resource connections_cosm_connection_on_prem 'Microsoft.Network/connections@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
  dependsOn: [
    localNetworkGateway
    virtualNetworkGateway
  ]
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateway.id
      properties: virtualNetworkGateway.properties
    }
    localNetworkGateway2:  {
      id: localNetworkGateway.id
      properties: localNetworkGateway.properties
    }
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    sharedKey: sharedKey
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    dpdTimeoutSeconds: 45
    connectionMode: 'Default'
    gatewayCustomBgpIpAddresses: []
  }
}
