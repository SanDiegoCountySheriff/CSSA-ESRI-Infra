@description('Location for all resources.') 
param location string = resourceGroup().location

param environment string = 'test'

@description('Deploy the shared hub vlan for cosm.') 
module cosmHubVirtualNetwork './modules/cosm/cosm-hub-vnet.bicep' = {
  name: 'deploy-cosm-shared-vnet'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    virtualNetworkAddressPrefixes: [
      '172.16.0.0/21'
    ]
  }
}

@description('Deploy the shared hub subnets.') 
module cosmHubVirtualNetworkSubnets './modules/cosm/cosm-hub-snet.bicep' = {
  name: 'deploy-cosm-shared-snet'
  params: {
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
    virtualNetworkGwSubnetAddressPrefix: '172.16.0.0/24'
    virtualNetworkFwSubnetAddressPrefix: '172.16.0.1/24'
  }
}

@description('Deploy the gis spoke vlan.') 
module gisVirtualNetwork './modules/cosm/cosm-spoke-vnet.bicep' = {
  name: 'deploy-gis-vnet'
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environment
    virtualNetworkHubName: cosmHubVirtualNetwork.outputs.name
    virtualNetworkAddressPrefixes: [
      '172.16.1.0/21'
    ]
  }
}

@description('Deploy the gis spoke subnets.') 
module gisVirtualNetworkSubnets './modules/gis/gis-snet.bicep' = {
  name: 'deploy-gis-snet'
  params: {
    resourceEnv: environment
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
  }
}

@description('Deploy the cosm gw public ip.') 
module virtualGatewayPublicIp './modules/cosm/cosm-public-ip.bicep' = {
  name: 'deploy-gw-pip'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    publicIpAddress: '20.237.174.76'
  }
}

@description('Deploy the local gateway to cosm lan.') 
module localNetworkGateway './modules/cosm/cosm-local-gateway.bicep' = {
  name: 'deploy-cosm-lng'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    localNetworkGatewayAddressPrefixes: [
      '10.0.0.0/8'
      '172.31.253.0/24'
    ]
    localNetworkGatewayIpAddress: '209.76.14.250'
  }
}

@description('Deploy the virtual gateway to azure.') 
module virtualNetworkGateway './modules/cosm/cosm-virtual-gateway.bicep' = {
  name: 'deploy-cosm-vng'
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environment
    virtualNetworkGatewayType: 'Vpn'
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
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    localNetworkGatewayName: localNetworkGateway.outputs.name
    virtualNetworkGatewayName: virtualNetworkGateway.outputs.name
    sharedKey: '$(NETWORKCONNECTIONSHAREDKEY)'
  }
}

