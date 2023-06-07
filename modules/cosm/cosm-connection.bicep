param connections_cosm_connection_on_prem_name string = 'cosm-connection-on-prem'

param localNetworkGatewayName string
param virtualNetworkGatewayName string
param sharedKey string
param location string


resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGatewayName
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' existing = {
  name: virtualNetworkGatewayName
}

resource connections_cosm_connection_on_prem 'Microsoft.Network/connections@2022-11-01' = {
  name: connections_cosm_connection_on_prem_name
  location: location
  properties: {
    virtualNetworkGateway1: localNetworkGateway
    localNetworkGateway2: virtualNetworkGateway
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
