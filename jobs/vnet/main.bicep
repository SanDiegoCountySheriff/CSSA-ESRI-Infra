// main.bicep | San Marcos GIS on Azure
//
// Copyright (C) 2023 City of San Marcos CA
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

@description('Location for all resources.')
param resourceLocation string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'tst'
  'prd'
  'dev'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

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

/*
@description('Deploy cosmHubVirtualNetwork')
module cosmHubVirtualNetwork '../../modules/cosm/cosm-vnet-hub.bicep' = {
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
*/
/*
@description('Deploy localNetworkGateway')
module localNetworkGateway '../../modules/cosm/cosm-lgw.bicep' = {
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
module virtualGatewayPublicIp '../../modules/cosm/cosm-pip.bicep' = {
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
module virtualNetworkGateway '../../modules/cosm/cosm-vgw.bicep' = {
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
module connection '../../modules/cosm/cosm-connection.bicep' = {
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
*/
@description('Deploy gisVirtualNetwork')
module gisVirtualNetwork '../../modules/cosm/cosm-vnet-spoke.bicep' = {
  name: 'deploy_gisVirtualNetwork'
  params: {
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

/*
@description('Enable Vnet Peering between Hub and Spoke') 
module virtualNetworkPeering '../../modules/cosm/cosm-peering.bicep' = {
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
*/
output SpokeVnetName string = gisVirtualNetwork.outputs.name
