@description('Location for all resources.') 
param location string = resourceGroup().location

module cosmHubVirtualNetwork './modules/cosm/cosm-vlan.bicep' = {
  name: 'deploy-hub001-vlan'
  params: {
    virtualNetworkName: 'hub001'
    virtualNetworkLocation: location
    virtualNetworkAddressPrefixes: [
      '172.16.0.0/21'
    ]
    virtualNetworkLocationSubnets: [
      
    ]
  }
}

module gisVirtualNetwork './modules/cosm/cosm-vlan.bicep' = {
  name: 'deploy-gis-vlan'
  params: {
    virtualNetworkName: 'gis-test'
    virtualNetworkLocation: location
    virtualNetworkAddressPrefixes: [
      '172.16.1.0/21'
    ]
    virtualNetworkLocationSubnets: [
      
    ]
  }
}

module virtualGatewayPublicIp './modules/cosm/cosm-public-ip.bicep' = {
  name: 'deploy-gw-pip-001'
  params: {
    publicIpAddressLocation: location
    publicIpAddressName: 'gw-pip-001'
    publicIpAddress: '20.237.174.76'
  }
}

module localNetworkGateway './modules/cosm/cosm-local-gateway.bicep' = {
  name: 'deploy-cosm-lng'
  params: {
    localNetworkGatewayLocation: location
    localNetworkGatewayAddressPrefixes: [
      '10.0.0.0/8'
      '172.31.253.0/24'
    ]
    localNetworkGatewayIpAddress: '209.76.14.250'
    localNetworkGatewayName: 'local-001'
  }
}

module virtualNetworkGateway './modules/cosm/cosm-virtual-gateway.bicep' = {
  name: 'deploy-cosm-vng'
  params: {
    virtualNetworkGatewayName: 'gis001'
    virtualNetworkGatewayType: 'Vpn'
    virtualNetworkGatewayLocation: location
    publicIpAddressId: virtualGatewayPublicIp.outputs.id
    virtualNetworkId: gisVirtualNetwork.outputs.id
    localNetworkGatewayName: localNetworkGateway.outputs.name
    vpnType: 'RouteBased'
  }
}

module connection './modules/cosm/cosm-connection.bicep' = {
  name: 'deploy-connection'
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

