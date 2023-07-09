
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
  'nonprod'
  'prod'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param spokeVnetName string

resource virtualNetworkSpoke 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: spokeVnetName
}

resource applicationSecurityGroup_Workstation 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: 'asg-gis-ws-${environmentType}-${resourceNameSuffix}'
  location: resourceLocation
  tags: {
    app: 'gis'
    tier: 'workstation'
    env: environmentType
  }
  properties: {}
}

resource applicationSecurityGroups_ArcGIS 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: 'asg-gis-arcgis-${environmentType}-${resourceNameSuffix}'
  location: resourceLocation
  tags: {
    app: 'gis'
    tier: 'workstation'
    env: environmentType
  }
  properties: {}
}

@description('Deploy networkSecurityGroup_gis-iz')
module networkSecurityGroup_gis_iz '../../modules/cosm/cosm-nsg.bicep' = {
  name: 'deploy_networkSecurityGroup_gis_ws'
  params: {
    nameSuffix: resourceNameSuffix
    resourceScope: 'shared'
    resourceLocation: resourceLocation
    resourceEnv: environmentType
    nsgScopeName: 'gisws'
    securityRules:  [
      {
        name: 'workstation-RDP-rule'
        properties: {
          description: 'allow RDP from virtual network'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroup_Workstation.id
            }
          ]
          access: 'Allow'
          priority: 500
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-RDP-rule'
        properties: {
          description: 'allow RDP from workstation'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroup_Workstation.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 600
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-SSH-rule'
        properties: {
          description: 'Allow SSH from workstation to ArcGIS Server Notebook'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroup_Workstation.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 610
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-SMB-rule'
        properties: {
          description: 'Allow RDP from workstation to ArcGIS'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '445'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroup_Workstation.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 620
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-6443-rule'
        properties: {
          description: 'allow arcgis server https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '6443'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 630
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-7443-rule'
        properties: {
          description: 'allow arcgis portal https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '7443'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 640
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-11443-rule'
        properties: {
          description: 'allow arcgis notebook https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '7443'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 650
          direction: 'Inbound'
        }
      }
      {
        name: 'arcgis-2443-rule'
        properties: {
          description: 'allow arcgis datastore https'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '2443'
          sourceApplicationSecurityGroups: [ 
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_ArcGIS.id
            }
          ]
          access: 'Allow'
          priority: 660
          direction: 'Inbound'
        }
      }
    ]
  }
}

module attachNsg '../../modules/cosm/cosm-sn-update.bicep' = {
  name: 'update-spoke-sn-001'
  scope: resourceGroup()
  params: {
    vnetName: spokeVnetName
    subnetName: virtualNetworkSpoke.properties.subnets[0].name
    properties: union(virtualNetworkSpoke.properties, {
      networkSecurityGroups: [{
        id: networkSecurityGroup_gis_iz.outputs.id
      }]
    })
  }
}
