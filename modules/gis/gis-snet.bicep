
param resourceAgency string = 'cosm'
param resourceType string = 'snet'
//param resourceName string
param resourceEnv string

param nameSuffix string = resourceEnv

param subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name string = 'app-${nameSuffix}'
param subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name string = 'data-${nameSuffix}'
//param subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name string = 'web-${nameSuffix}'
//param subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name string = 'ws-${nameSuffix}'

param virtualNetworkName string

resource virtualNetworks_cosm_gis_int_vlan 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: virtualNetworkName
}

resource subnets_cosm_gis_int_vlan_cosm_gis_app_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name
  properties: {
    addressPrefix: '172.16.1.0/25'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}


resource subnets_cosm_gis_int_vlan_cosm_gis_data_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name
  properties: {
    addressPrefix: '172.16.1.128/25'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}
/*
resource subnets_cosm_gis_int_vlan_cosm_gis_web_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name
  properties: {
    addressPrefix: '172.16.2.128/26'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

resource subnets_cosm_gis_int_vlan_cosm_gis_ws_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_int_vlan
  name: subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name
  properties: {
    addressPrefix: '172.16.2.192/26'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

*/
