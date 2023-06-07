


@description('Load variables for all resources.') 
var sharedVariables = loadJsonContent('./shared-variables.json')

resource virtualNetworks_cosm_gis_vlan 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: sharedVariables.resources.vlan1.name
}

resource virtualNetworks_cosm_gis_vlan_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${sharedVariables.resources.vlan1.name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: '172.16.5.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_app_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${sharedVariables.resources.vlan1.name}/cosm-gis-app-sn'
  properties: {
    addressPrefix: '172.16.3.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_data_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${sharedVariables.resources.vlan1.name}/cosm-gis-data-sn'
  properties: {
    addressPrefix: '172.16.4.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_pubweb_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${sharedVariables.resources.vlan1.name}/cosm-gis-pubweb-sn'
  properties: {
    addressPrefix: '172.16.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_ws_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${sharedVariables.resources.vlan1.name}/cosm-gis-ws-sn'
  properties: {
    addressPrefix: '172.16.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${sharedVariables.resources.vlan1.name}/GatewaySubnet'
  properties: {
    addressPrefix: '172.16.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan
  ]
}
