
param resourceAgency string = 'cosm'
param resourceType string = 'vgw'
param resourceScope string
param resourceEnv string
param resourceLocation string
param resourceNumber string = '001'

param namePrefix string = '${resourceType}-${resourceAgency}'
param nameSuffix string = '${resourceEnv}-${resourceNumber}'

param virtualNetworkGatewayIpAddressName string
param virtualNetworkName string

param virtualNetworkGatewayType string
param vpnType string
param sku string
param allowRemoteVnetTraffic bool = false
param allowVirtualWanTraffic bool = false

param localNetworkGatewayName string
resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2022-11-01' existing = {
  name: localNetworkGatewayName
}

resource virtualNetworkHubVnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkName
}

resource virtualNetworkGwSn 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name : 'GatewaySubnet'
  parent: virtualNetworkHubVnet
}

resource virtualNetworkGatewayIp 'Microsoft.Network/publicIPAddresses@2022-11-01' existing = {
  name: virtualNetworkGatewayIpAddressName
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2022-11-01' = {
  name: '${namePrefix}-${resourceScope}-${nameSuffix}'
  location: resourceLocation
  dependsOn: [
    virtualNetworkGatewayIp
    virtualNetworkGwSn
    localNetworkGateway
  ]
  properties: {
    gatewayType: virtualNetworkGatewayType
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: virtualNetworkGatewayIp
          subnet: virtualNetworkGwSn
        }
      }
    ]
    //natRules: []
    //virtualNetworkGatewayPolicyGroups: []
    //enableBgpRouteTranslationForNat: false
    //disableIPSecReplayProtection: false
    sku: {
      name: sku
      tier: sku
    }
    vpnType: vpnType
    enableBgp: false
    activeActive: false
    /*
    bgpSettings: {
      asn: 65515
      peerWeight: 0
      bgpPeeringAddress: localNetworkGateway.properties.bgpSettings.bgpPeeringAddress
    }
    */
    vpnGatewayGeneration: 'Generation2'
    //allowRemoteVnetTraffic: allowRemoteVnetTraffic
    //allowVirtualWanTraffic: allowVirtualWanTraffic
  }

}

output id string = virtualNetworkGateway.id
output name string = virtualNetworkGateway.name
