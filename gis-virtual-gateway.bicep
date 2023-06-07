param location string
param gatewayType string
param vpnType string
param sku object

param localNetworkGatewayName string
resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGatewayName
}
param publicIpAddressName string
resource publicIPAddresses_cosm_virtual_gateway 'Microsoft.Network/publicIPAddresses@2022-11-01' existing = {
  name: publicIpAddressName
}

param virtualNetworkName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworkName
}

param virtualNetworkGatewayName string

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' = {
  name: virtualNetworkGatewayName
  location: location
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetwork.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_cosm_virtual_gateway.id
          }
          subnet: {
            id: '${virtualNetwork.id}/subnets/GatewaySubnet'
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: sku
    gatewayType: gatewayType
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
