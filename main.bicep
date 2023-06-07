@description('Location for all resources.') 
param location string = resourceGroup().location


module localNetworkGateway './local-network-gateway.bicep' = {
  name: 'LocalNetworkGateway'
  params: {
    localNetworkGatewayLocation: location
    localNetworkGatewayAddressPrefixes: [
      '10.0.0.0/8'
      '172.31.253.0/24'
    ]
    localNetworkGatewayIpAddress: '209.76.14.250'
    localNetworkGatewayName: 'cosm-sharedservices-001'
  }
}

module virtualNetworkGateway './gis-virtual-gateway.bicep' = {
  name: 'VirtualNetworkGateway'
  params: {
    gatewayType: 'Vpn'
    location: location
    publicIpAddressName: 'pip-cosm-gis-vng'
    sku: {
      name: 'VpnGw2'
      tier: 'VpnGw2'
    }
    virtualNetworkGatewayName: 'cosm-gis-vng'
    virtualNetworkName: 'cosm-pub-vlan'
    localNetworkGatewayName: localNetworkGateway.outputs.name
    vpnType: 'RouteBased'
  }
}

module connection './connection-on-prem.bicep' = {
  name: 'connection'
  params: {
    connectionName: 'sharedservices-001'
    connectionType: 'IPSec'
    enableBgp: false
    localNetworkGatewayName: localNetworkGateway.outputs.name
    location: location
    sharedKey: '$(NETWORKCONNECTIONSHAREDKEY)'
    virtualNetworkGatewayName: virtualNetworkGateway.outputs.name
  }
}

