param prefixName string = 'cosm'
param suffixName string = 'vng'

param virtualNetworkGatewayName string
param virtualNetworkGatewayLocation string
param virtualNetworkGatewayIpAddressId string
param virtualNetworkId string

param virtualNetworkGatewayType string
param vpnType string

param localNetworkGatewayName string
resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGatewayName
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' = {
  name: '${prefixName}-${virtualNetworkGatewayName}-${suffixName}'
  location: virtualNetworkGatewayLocation
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkId}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: virtualNetworkGatewayIpAddressId
          }
          subnet: {
            id: '${virtualNetworkId}/subnets/GatewaySubnet'
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
    gatewayType: virtualNetworkGatewayType
    vpnType: vpnType
    enableBgp: false
    activeActive: false
    bgpSettings: {
      asn: 65515
      peerWeight: 0
      bgpPeeringAddresse: localNetworkGateway.properties.bgpSettings.bgpPeeringAddress
    }
    vpnGatewayGeneration: 'Generation2'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}

output id string = virtualNetworkGateway.id
output name string = virtualNetworkGateway.name
