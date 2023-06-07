@description('Location for all resources.') 
param location string = resourceGroup().location

param environment string = 'test'

@description('Deploy vnet-cosm-shared-test-001') 
module cosmHubVirtualNetwork './modules/cosm/cosm-hub-vnet.bicep' = {
  name: 'deploy_vnet-cosm-shared-test-001'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    virtualNetworkAddressPrefixes: [
      '172.16.0.0/21'
    ]
  }
}

@description('Deploy snet-cosm-shared-test-001') 
module cosmHubVirtualNetworkSubnets './modules/cosm/cosm-hub-snet.bicep' = {
  name: 'deploy_snet-cosm-shared-test-001'
  params: {
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
    virtualNetworkGwSubnetAddressPrefix: '172.16.0.0/24'
    virtualNetworkFwSubnetAddressPrefix: '172.16.0.1/24'
  }
}

@description('Deploy vnet-cosm-gis-test-001') 
module gisVirtualNetwork './modules/cosm/cosm-spoke-vnet.bicep' = {
  name: 'deploy_vnet-cosm-gis-test-001'
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

@description('Deploy snet-cosm-gis-test-001') 
module gisVirtualNetworkSubnets './modules/gis/gis-snet.bicep' = {
  name: 'deploy_snet-cosm-gis-test-001'
  params: {
    resourceEnv: environment
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
  }
}

@description('Deploy pip-cosm-shared-test-001') 
module virtualGatewayPublicIp './modules/cosm/cosm-public-ip.bicep' = {
  name: 'deploy_pip-cosm-shared-test-001'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    publicIpAddress: '20.237.174.76'
  }
}

@description('Deploy lgw-cosm-shared-test-001') 
module localNetworkGateway './modules/cosm/cosm-local-gateway.bicep' = {
  name: 'deploy_lgw-cosm-shared-test-001'
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

@description('Deploy vgw-cosm-gis-test-001') 
module virtualNetworkGateway './modules/cosm/cosm-virtual-gateway.bicep' = {
  name: 'deploy_vgw-cosm-gis-test-001'
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


@description('Deploy con-cosm-shared-test-001') 
module connection './modules/cosm/cosm-connection.bicep' = {
  name: 'deploy_con-cosm-shared-test-001'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environment
    localNetworkGatewayName: localNetworkGateway.outputs.name
    virtualNetworkGatewayName: virtualNetworkGateway.outputs.name
    sharedKey: '$(NETWORKCONNECTIONSHAREDKEY)'
  }
}

