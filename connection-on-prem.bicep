param connections_cosm_connection_on_prem_name string = 'cosm-connection-on-prem'
param virtualNetworkGateways_cosm_gis_virtual_gateway_externalid string = '/subscriptions/66d233df-ad0c-45a4-a6bc-d77919e18237/resourceGroups/gis-azure-vnet-dev/providers/Microsoft.Network/virtualNetworkGateways/cosm-gis-virtual-gateway'
param localNetworkGateways_cosm_local_network_gateway_externalid string = '/subscriptions/66d233df-ad0c-45a4-a6bc-d77919e18237/resourceGroups/gis-azure-vnet-dev/providers/Microsoft.Network/localNetworkGateways/cosm-local-network-gateway'

param localNetworkGatewayName string = 'local-network-gateway'
resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGatewayName
}

param virtualNetworkGatewayName string = 'local-network-gateway'
resource virtualNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: virtualNetworkGatewayName
}

resource connections_cosm_connection_on_prem 'Microsoft.Network/connections@2022-11-01' = {
  name: connections_cosm_connection_on_prem_name
  location: 'westus'
  properties: {
    virtualNetworkGateway1: virtualNetworkGateway
    localNetworkGateway2: localNetworkGateway
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    sharedKey: '$(NETWORKCONNECTIONSHAREDKEY)'
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
