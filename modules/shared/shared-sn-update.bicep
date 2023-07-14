param vnetName string
param subnetName string
param properties object

// Get existing vnet
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: subnetName
  parent: vnet
  properties: properties
}
