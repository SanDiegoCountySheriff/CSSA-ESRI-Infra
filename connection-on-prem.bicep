param connections_cosm_connection_on_prem_name string = 'cosm-connection-on-prem'
param virtualNetworkGateways_cosm_gis_virtual_gateway_externalid string = '/subscriptions/66d233df-ad0c-45a4-a6bc-d77919e18237/resourceGroups/gis-azure-vnet-dev/providers/Microsoft.Network/virtualNetworkGateways/cosm-gis-virtual-gateway'
param localNetworkGateways_cosm_local_network_gateway_externalid string = '/subscriptions/66d233df-ad0c-45a4-a6bc-d77919e18237/resourceGroups/gis-azure-vnet-dev/providers/Microsoft.Network/localNetworkGateways/cosm-local-network-gateway'

resource connections_cosm_connection_on_prem_name_resource 'Microsoft.Network/connections@2022-11-01' = {
  name: connections_cosm_connection_on_prem_name
  location: 'westus'
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_cosm_gis_virtual_gateway_externalid
      properties: {}
    }
    localNetworkGateway2: {
      id: localNetworkGateways_cosm_local_network_gateway_externalid
      properties: {}
    }
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
