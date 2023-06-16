//param namePrefix string = 'cosm'
//param nameSuffix string = 'sn'

param virtualNetworkName string
param virtualNetworkGwSubnetAddressPrefix string
param virtualNetworkFwSubnetAddressPrefix string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkName
}

resource cosmGatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetwork
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: virtualNetworkGwSubnetAddressPrefix
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource cosmFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetwork
  name: 'AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: virtualNetworkFwSubnetAddressPrefix
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
