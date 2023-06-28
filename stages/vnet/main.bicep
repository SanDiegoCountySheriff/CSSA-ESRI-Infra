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
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])

param environmentType string
param localNetworkGatewayIpAddress string = '209.76.14.250'
param networkConnectionSharedKey string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)


@description('Deploy vnet-cosm-shared-test-001')
module cosmHubVirtualNetwork './modules/cosm/cosm-hub-vnet.bicep' = {
  name: 'deploy_vnet-cosm-shared-test-001'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environmentType
    virtualNetworkAddressPrefixes: [
      '172.18.0.0/23'
    ]
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '172.18.0.0/25'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }

      {
        name: 'AzureFirewallManagementSubnet'
        properties: {
          addressPrefix: '172.18.0.128/25'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'sn-cosm-appgw'
        properties: {
          addressPrefix: '172.18.1.0/25'
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

@description('Deploy vnet-cosm-gis-test-001')
module gisVirtualNetwork './modules/cosm/cosm-spoke-vnet.bicep' = {
  name: 'deploy_vnet-cosm-gis-test-001'
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environmentType
    virtualNetworkAddressPrefixes: [
      '172.18.2.0/24'
    ]
    subnets: [
      {
        name: 'cosm-gis-app-sn'
        properties: {
          addressPrefix: '172.18.2.0/25'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'cosm-gis-data-sn'
        properties: {
          addressPrefix: '172.18.2.128/25'
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

@description('Deploy lgw-cosm-shared-test-001')
module localNetworkGateway './modules/cosm/cosm-local-gateway.bicep' = {
  name: 'deploy_lgw-cosm-shared-test-001'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environmentType
    localNetworkGatewayAddressPrefixes: [
      '10.0.0.0/8'
      '172.31.253.0/24'
    ]
    localNetworkGatewayIpAddress: localNetworkGatewayIpAddress
  }
}

@description('Deploy pip-cosm-shared-test-001')
module virtualGatewayPublicIp './modules/cosm/cosm-public-ip.bicep' = {
  name: 'deploy_pip-cosm-shared-test-001'
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environmentType
    publicIpAddress: '20.237.174.76'
  }
}

@description('Deploy vgw-cosm-gis-test-001')
module virtualNetworkGateway './modules/cosm/cosm-virtual-gateway.bicep' = {
  name: 'deploy_vgw-cosm-gis-test-001'
  dependsOn: [
    virtualGatewayPublicIp
    localNetworkGateway
  ]
  params: {
    resourceScope: 'gis'
    resourceLocation: location
    resourceEnv: environmentType
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
module connection './modules/cosm/cosm-connection.bicep' = {
  name: 'deploy_con-cosm-shared-test-001'
  dependsOn: [
    localNetworkGateway
    virtualNetworkGateway
  ]
  params: {
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environmentType
    localNetworkGatewayName: 'lgw-cosm-shared-nonprod-001'
    virtualNetworkGatewayName: 'vgw-cosm-gis-nonprod-001'
    sharedKey: networkConnectionSharedKey
  }
}

@description('Enable Vnet Peering between Hub and Spoke') 
module virtualNetworkPeering './modules/cosm/cosm-peering.bicep' = {
  name: 'deploy_vnp-cosm-gis-test-001'
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
