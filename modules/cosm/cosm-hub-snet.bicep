param namePrefix string = 'cosm'
param nameSuffix string = 'sn'

param virtualNetworkName string
param virtualNetworkGwSubnetAddressPrefix string
param virtualNetworkFwSubnetAddressPrefix string
param virtualNetworkAppGwSubnetAddressPrefix string

param subnets_cosm_hub_int_vlan_cosm_hub_app_sn_name string = '${namePrefix}-appgw-${nameSuffix}'

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
    //privateEndpointNetworkPolicies: 'Enabled'
    //privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource cosmFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetwork
  name: 'AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: virtualNetworkFwSubnetAddressPrefix
    serviceEndpoints: []
    delegations: []
    //privateEndpointNetworkPolicies: 'Enabled'
    //privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource cosmAppGatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetwork
  name: subnets_cosm_hub_int_vlan_cosm_hub_app_sn_name
  properties: {
    addressPrefix: virtualNetworkAppGwSubnetAddressPrefix
    serviceEndpoints: []
    delegations: []
    //privateEndpointNetworkPolicies: 'Enabled'
    //privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
