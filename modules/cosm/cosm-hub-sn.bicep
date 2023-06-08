//param namePrefix string = 'cosm'
//param nameSuffix string = 'sn'

param virtualNetworkName string
param virtualNetworkGwSubnetAddressPrefix string = '172.16.0.0/24'
param virtualNetworkFwSubnetAddressPrefix string = '172.16.0.1/24'

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
    privateEndpointNetworkPolicies: 'Disabled'
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
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
