
param globalAgencyName string = 'cosm'
param globalApplicationName string = 'gis'
param globalPrefix string = '${globalAgencyName}-${globalApplicationName}'

param subnets_cosm_gis_pub_vlan_AzureFirewall_sn_name string = 'AzureFirewallManagementSubnet'
param subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name string = '${globalPrefix}-app-sn'
param subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name string = '${globalPrefix}-web-sn'
param subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name string = '${globalPrefix}-ws-sn'
param subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name string = '${globalPrefix}-data-sn'

param virtualNetworks_cosm_pub_vlan_name string = '${globalAgencyName}-pub-vlan'
param virtualNetworks_cosm_gis_int_vlan_name string = '${globalPrefix}-vlan'

resource virtualNetworks_cosm_gis_int_vlan 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworks_cosm_gis_int_vlan_name
}

resource virtualNetworks_cosm_pub_vlan 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworks_cosm_pub_vlan_name
}

resource subnets_cosm_gis_int_vlan_cosm_gis_app_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name
  properties: {
    addressPrefix: '172.16.3.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnets_cosm_gis_int_vlan_cosm_gis_data_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name
  properties: {
    addressPrefix: '172.16.4.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnets_cosm_gis_int_vlan_cosm_gis_web_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name
  properties: {
    addressPrefix: '172.16.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnets_cosm_gis_int_vlan_cosm_gis_ws_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name
  properties: {
    addressPrefix: '172.16.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource subnets_cosm_gis_pub_vlan_AzureFirewall_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_pub_vlan
  name: subnets_cosm_gis_pub_vlan_AzureFirewall_sn_name
  properties: {
    addressPrefix: '172.16.5.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_cosm_gis_pub_vlan_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_pub_vlan
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: '172.16.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
