
@description('Location for all resources.')
param resourceLocation string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'prd'
  'stg'
  'ist'
  'uat'
  'dev'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param resourceAgency string = 'cosm'

param localNetworkGatewayIpAddress string = '209.76.14.250'

@secure()
param networkConnectionSharedKey string

var localNetworkGatewayAddressPrefixes = [
  '10.0.0.0/8'
  '172.31.253.0/24'
]

var cosmHubVirtualNetworkAddressPrefix = '172.18.0.0/23'
var cosmHubVirtualNetworkGatewaySubnetPrefix = '172.18.0.0/25'
var cosmHubVirtualNetworkFwSubnetPrefix = '172.18.0.128/25'
var cosmHubVirtualNetworkAppGwSubnetPrefix = '172.18.1.0/25'

var gisVirtualNetworkAddressPrefix = '172.18.2.0/24'
var gisVirtualNetworkIzSubnetPrefix = '172.18.2.0/25'
var gisVirtualNetworkDataSubnetPrefix = '172.18.2.128/25'

@description('Deploy cosmHubVirtualNetwork')
module cosmHubVirtualNetwork '../../modules/shared/shared-vnet-hub.bicep' = {
  name: 'deploy_cosmHubVirtualNetwork'
  params: {
    resourceScope: 'shared'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualNetworkAddressPrefixes: [
      cosmHubVirtualNetworkAddressPrefix
    ]
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: cosmHubVirtualNetworkGatewaySubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureFirewallManagementSubnet'
        properties: {
          addressPrefix: cosmHubVirtualNetworkFwSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'sn-cosm-appgw'
        properties: {
          addressPrefix: cosmHubVirtualNetworkAppGwSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

@description('Deploy localNetworkGateway')
module localNetworkGateway '../../modules/shared/shared-lgw.bicep' = {
  name: 'deploy_localNetworkGateway'
  params: {
    resourceScope: 'shared'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    localNetworkGatewayAddressPrefixes: localNetworkGatewayAddressPrefixes
    localNetworkGatewayIpAddress: localNetworkGatewayIpAddress
  }
}

@description('Deploy virtualGatewayPublicIp')
module virtualGatewayPublicIp '../../modules/shared/shared-pip.bicep' = {
  name: 'deploy_virtualGatewayPublicIp'
  params: {
    resourceScope: 'shared'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    publicIpAddress: '20.237.174.77'
  }
}

@description('Deploy virtualNetworkGateway')
module virtualNetworkGateway '../../modules/shared/shared-vgw.bicep' = {
  name: 'deploy_virtualNetworkGateway'
  dependsOn: [
    virtualGatewayPublicIp
    localNetworkGateway
  ]
  params: {
    resourceScope: 'shared'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualNetworkGatewayType: 'Vpn'
    virtualNetworkGatewayIpAddressName: virtualGatewayPublicIp.outputs.name
    virtualNetworkName: cosmHubVirtualNetwork.outputs.name
    localNetworkGatewayName: localNetworkGateway.outputs.name
    vpnType: 'RouteBased'
    sku: 'VpnGw2'
    allowRemoteVnetTraffic: true
    allowVirtualWanTraffic: true
  }
}

@description('Deploy con-cosm-shared-test-001')
module connection '../../modules/shared/shared-connection.bicep' = {
  name: 'deploy_connection'
  dependsOn: [
    localNetworkGateway
    virtualNetworkGateway
  ]
  params: {
    resourceScope: 'shared'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    localNetworkGatewayName: localNetworkGateway.outputs.name
    virtualNetworkGatewayName: virtualNetworkGateway.outputs.name
    sharedKey: networkConnectionSharedKey
  }
}

@description('Deploy gisVirtualNetwork')
module gisVirtualNetwork '../../modules/shared/shared-vnet-spoke.bicep' = {
  name: 'deploy_gisVirtualNetwork'
  params: {
    resourceAgency: resourceAgency
    resourceScope: 'gis'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nameSuffix: resourceNameSuffix
    virtualNetworkAddressPrefixes: [
      gisVirtualNetworkAddressPrefix     
    ]
    subnets: [
      {
        name: 'sn-cosm-gis-iz'
        properties: {
          addressPrefix: gisVirtualNetworkIzSubnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'sn-cosm-gis-data'
        properties: {
          addressPrefix: gisVirtualNetworkDataSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

@description('Enable Vnet Peering between Hub and Spoke') 
module virtualNetworkPeering '../../modules/shared/shared-peering.bicep' = {
  name: 'deploy_virtualNetworkPeering'
  dependsOn: [
    gisVirtualNetwork
    cosmHubVirtualNetwork
    localNetworkGateway
    virtualNetworkGateway
    connection
  ]
  params: {
    virtualNetworkHubName: cosmHubVirtualNetwork.outputs.name
    virtualNetworkSpokeName: gisVirtualNetwork.outputs.name

    spokeAllowForwardedTraffic: true
    spokeAllowVirtualNetworkAccess: true
    spokeUseRemoteGateways: true
    spokeAllowGatewayTransit: false

    hubAllowForwardedTraffic: false
    hubAllowVirtualNetworkAccess: true
    hubUseRemoteGateways: false
    hubAllowGatewayTransit: true
  }
}

output SpokeVnetName string = gisVirtualNetwork.outputs.name
