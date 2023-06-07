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

resource virtualNetwork1 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'public-vlan'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/21'
      ]
    }
    subnets: [
      {
        name: 'gateway-subnet'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
    ]
  }
}

resource virtualNetwork2 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'private-vlan'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.17.0.0/21'
      ]
    }
    subnets: [
      {
        name: 'gis-pubweb-subnet'
        properties: {
          addressPrefix: '172.17.1.0/24'
        }
      }
      {
        name: 'gis-ws-subnet'
        properties: {
          addressPrefix: '172.17.2.0/24'
        }
      }
      {
        name: 'gis-app-subnet'
        properties: {
          addressPrefix: '172.17.3.0/24'
        }
      }
      {
        name: 'gis-data-subnet'
        properties: {
          addressPrefix: '172.17.4.0/24'
        }
      }
    ]
  }
}

