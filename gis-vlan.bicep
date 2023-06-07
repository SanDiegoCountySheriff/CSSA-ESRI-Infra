@description('Load variables for all resources.') 
var sharedVariables = loadYamlContent('./shared-variables.yaml')

@description('Location for all resources.') 
param location string = resourceGroup().location

resource subnet1 'subnets' existing = {
  name: subnet1Name
}

resource virtualNetworks_cosm_gis_vlan 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: sharedVariables.resources.vlan1.name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/21'
      ]
    }
    subnets: [ 

    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
