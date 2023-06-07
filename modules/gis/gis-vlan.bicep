
param location string = resourceGroup().location

param globalAgencyName string = 'cosm'
param globalApplicationName string = 'gis'
param globalPrefix string = '${globalAgencyName}-${globalApplicationName}'

param virtualNetworks_cosm_gis_int_vlan_name string = '${globalPrefix}-vlan'

param subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name string = '${globalPrefix}-app-sn'
param subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name string = '${globalPrefix}-web-sn'
param subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name string = '${globalPrefix}-ws-sn'
param subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name string = '${globalPrefix}-data-sn'

resource subnets_cosm_gis_int_vlan_cosm_gis_app_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: subnets_cosm_gis_int_vlan_cosm_gis_app_sn_name
}

resource subnets_cosm_gis_int_vlan_cosm_gis_web_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: subnets_cosm_gis_int_vlan_cosm_gis_web_sn_name
}

resource subnets_cosm_gis_int_vlan_cosm_gis_ws_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: subnets_cosm_gis_int_vlan_cosm_gis_ws_sn_name
}

resource subnets_cosm_gis_int_vlan_cosm_gis_data_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: subnets_cosm_gis_int_vlan_cosm_gis_data_sn_name
}

resource virtualNetworks_cosm_gis_int_vlan 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: virtualNetworks_cosm_gis_int_vlan_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/21'
      ]
    }
    subnets: [ 
      subnets_cosm_gis_int_vlan_cosm_gis_app_sn
      subnets_cosm_gis_int_vlan_cosm_gis_web_sn
      subnets_cosm_gis_int_vlan_cosm_gis_ws_sn
      subnets_cosm_gis_int_vlan_cosm_gis_data_sn
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

output id string = virtualNetworks_cosm_gis_int_vlan.id
output name string = virtualNetworks_cosm_gis_int_vlan.name
