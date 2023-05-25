@description('Location for all resources.') 
param location string = resourceGroup().location

resource virtualNetwork1 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'public-vlan'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
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
        '172.17.0.0/16'
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

