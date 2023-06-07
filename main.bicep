@description('Location for all resources.') 
param location string = resourceGroup().location

@description('Deploy the shared hub vlan for cosm.') 
module cosmHubVirtualNetwork './modules/cosm/cosm-hub-vlan.bicep' = {
  name: 'deploy-cosm-hub-vlan'
  params: {
    virtualNetworkName: 'cosm-hub'
    virtualNetworkLocation: location
    virtualNetworkAddressPrefixes: [
      '172.16.0.0/21'
    ]
  }
}

@description('Deploy the shared hub subnets.') 
module cosmHubVirtualNetworkSubnets './modules/cosm/cosm-hub-sn.bicep' = {
  name: 'deploy-cosm-hub-sn'
  params: {
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
    virtualNetworkGwSubnetAddressPrefix: '172.16.0.0/24'
    virtualNetworkFwSubnetAddressPrefix: '172.16.0.1/24'
  }
}

@description('Deploy the gis spoke vlan.') 
module gisVirtualNetwork './modules/cosm/cosm-spoke-vlan.bicep' = {
  name: 'deploy-gis-vlan'
  params: {
    virtualNetworkHubName: cosmHubVirtualNetwork.outputs.name
    virtualNetworkName: 'gis-test'
    virtualNetworkLocation: location
    virtualNetworkAddressPrefixes: [
      '172.16.1.0/21'
    ]
  }
}

@description('Deploy the gis spoke subnets.') 
module gisVirtualNetworkSubnets './modules/gis/gis-sn.bicep' = {
  name: 'deploy-gis-sn'
  params: {
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
  }
}

@description('Deploy the gis spoke vlan.') 
module virtualGatewayPublicIp './modules/cosm/cosm-public-ip.bicep' = {
  name: 'deploy-gw-pip-001'
  params: {
    publicIpAddressLocation: location
    publicIpAddressName: 'gw-pip-001'
    publicIpAddress: '20.237.174.76'
  }
}

@description('Deploy the local gateway to cosm lan.') 
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


@description('Deploy the virtual gateway to azure.') 
module virtualNetworkGateway './modules/cosm/cosm-virtual-gateway.bicep' = {
  name: 'deploy-cosm-vng'
  params: {
    virtualNetworkGatewayName: 'gis001'
    virtualNetworkGatewayType: 'Vpn'
    virtualNetworkGatewayLocation: location
    virtualNetworkGatewayIpAddressId: virtualGatewayPublicIp.outputs.id
    virtualNetworkId: gisVirtualNetwork.outputs.id
    localNetworkGatewayName: localNetworkGateway.outputs.name
    vpnType: 'RouteBased'
  }
}


@description('Deploy the connection between cosm lan and azure.') 
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

