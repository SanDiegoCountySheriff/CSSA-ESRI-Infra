@description('Load variables for all resources.') 
var globalVars = loadYamlContent('./shared-variables.yaml')

var agencyName = globalVars.tags.agency
var appName = globalVars.tags.app
var pubZoneName = globalVars.tags.zone.public
var intZoneName = globalVars.tags.zone.internal
var appTierName = globalVars.tags.tiers.application
var dataTierName = globalVars.tags.tiers.data
var webTierName = globalVars.tags.tiers.data
var wsTierName =  globalVars.tags.tiers.workstation

resource virtualNetworks_cosm_gis_vlan 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: globalVars.resources.vlan1.name
}

resource virtualNetworks_cosm_gis_vlan_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_vlan
  name: 'AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: '172.16.5.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_app_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_vlan
  name: '${agencyName}-${appName}-${appTierName}-${intZoneName}-sn'
  properties: {
    addressPrefix: '172.16.3.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_data_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_vlan
  name: '${agencyName}-${appName}-${dataTierName}-${intZoneName}-sn'
  properties: {
    addressPrefix: '172.16.4.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_pubweb_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_vlan
  name: '${agencyName}-${appName}-${webTierName}-${pubZoneName}-sn'
  properties: {
    addressPrefix: '172.16.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_ws_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_vlan
  name: '${agencyName}-${appName}-${wsTierName}-${pubZoneName}-sn'
  properties: {
    addressPrefix: '172.16.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetworks_cosm_gis_vlan_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  parent: virtualNetworks_cosm_gis_vlan
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: '172.16.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
