
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

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param spokeVnetName string
param spokeVnetSubnets string
param spokeVnetSubnetArray array = array(spokeVnetSubnets)

@description('Deploy cosm-ssh-rdp-in-nsg')
module nsg '../../modules/cosm/cosm-ssh-rdp-in-nsg.bicep' = {
  name: 'deploy_cosm-ssh-rdp-in-nsg.bicep'
  params: {
    nameSuffix: resourceNameSuffix
    resourceScope: 'shared'
    resourceLocation: location
    resourceEnv: environmentType
  }
}

@batchSize(1)
module attachSshNsg '../../modules/cosm/cosm-update-sn.bicep' = [for (sn, index) in spokeVnetSubnetArray: {
  name: 'update-vnet-subnet-${sn})}'
  params: {
    vnetName: spokeVnetName
    subnetName: sn.name
    properties: union(sn.properties, {
      networkSecurityGroups: [{
        id: nsg.outputs.id
      }]
    })
  }
}]
