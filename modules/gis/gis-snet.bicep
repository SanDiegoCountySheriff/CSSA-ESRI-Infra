
param resourceAgency string = 'cosm'
param resourceType string = 'snet'
//param resourceName string
param resourceEnv string
//param resourceLocation string
param resourceNumber string = '001'

param namePrefix string = '${resourceType}-${resourceAgency}-${resourceEnv}'
param nameSuffix string = resourceNumber

param subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name string = '${namePrefix}-app-${nameSuffix}'
param subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name string = '${namePrefix}-web-${nameSuffix}'
param subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name string = '${namePrefix}-ws-${nameSuffix}'
param subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name string = '${namePrefix}-data-${nameSuffix}'

param virtualNetworkName string

resource virtualNetworks_cosm_gis_int_vlan 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworkName
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

