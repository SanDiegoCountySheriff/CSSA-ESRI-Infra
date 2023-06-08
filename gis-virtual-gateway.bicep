param virtualNetworkGateways_cosm_gis_virtual_gateway_name string = 'cosm-gis-virtual-gateway'
param publicIPAddresses_cosm_virtual_gateway_externalid string = '/subscriptions/66d233df-ad0c-45a4-a6bc-d77919e18237/resourceGroups/gis-azure-vnet-dev/providers/Microsoft.Network/publicIPAddresses/cosm-virtual-gateway'
param virtualNetworks_cosm_gis_vlan_externalid string = '/subscriptions/66d233df-ad0c-45a4-a6bc-d77919e18237/resourceGroups/gis-azure-vnet-dev/providers/Microsoft.Network/virtualNetworks/cosm-gis-vlan'

param localNetworkGateways_cosm_virtual_gateway_name string = 'cosm-virtual-gateway'

resource localNetworkGateways_cosm_virtual_gateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGateways_cosm_virtual_gateway_name
}

param virtualNetworks_cosm_pub_vlan_name string = 'cosm-pub-vlan'
resource virtualNetworks_cosm_pub_vlan 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworks_cosm_pub_vlan_name
}

resource virtualNetworkGateways_cosm_gis_virtual_gateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' = {
  name: virtualNetworkGateways_cosm_gis_virtual_gateway_name
  location: 'westus'
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'default'
        id: '${localNetworkGateways_cosm_virtual_gateway.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: localNetworkGateways_cosm_virtual_gateway.properties.gatewayIpAddress
          }
          subnet: {
            id: '${virtualNetworks_cosm_pub_vlan.id}/subnets/GatewaySubnet'
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw2'
      tier: 'VpnGw2'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '172.16.0.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_cosm_gis_virtual_gateway.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation2'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}
