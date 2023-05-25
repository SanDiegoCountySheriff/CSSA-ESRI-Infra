param virtualNetworks_cosm_gis_vlan_name string = 'cosm-gis-vlan'

resource virtualNetworks_cosm_gis_vlan_name_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: virtualNetworks_cosm_gis_vlan_name
  location: 'westus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/21'
      ]
    }
    subnets: [
      {
        name: 'cosm-gis-pubweb-sn'
        id: virtualNetworks_cosm_gis_vlan_name_cosm_gis_pubweb_sn.id
        properties: {
          addressPrefix: '172.16.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'cosm-gis-ws-sn'
        id: virtualNetworks_cosm_gis_vlan_name_cosm_gis_ws_sn.id
        properties: {
          addressPrefix: '172.16.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'cosm-gis-app-sn'
        id: virtualNetworks_cosm_gis_vlan_name_cosm_gis_app_sn.id
        properties: {
          addressPrefix: '172.16.3.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'cosm-gis-data-sn'
        id: virtualNetworks_cosm_gis_vlan_name_cosm_gis_data_sn.id
        properties: {
          addressPrefix: '172.16.4.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_cosm_gis_vlan_name_GatewaySubnet.id
        properties: {
          addressPrefix: '172.16.0.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'AzureFirewallManagementSubnet'
        id: virtualNetworks_cosm_gis_vlan_name_AzureFirewallManagementSubnet.id
        properties: {
          addressPrefix: '172.16.5.0/24'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_cosm_gis_vlan_name_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_cosm_gis_vlan_name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: '172.16.5.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan_name_resource
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_app_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_cosm_gis_vlan_name}/cosm-gis-app-sn'
  properties: {
    addressPrefix: '172.16.3.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan_name_resource
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_data_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_cosm_gis_vlan_name}/cosm-gis-data-sn'
  properties: {
    addressPrefix: '172.16.4.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan_name_resource
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_pubweb_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_cosm_gis_vlan_name}/cosm-gis-pubweb-sn'
  properties: {
    addressPrefix: '172.16.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan_name_resource
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_cosm_gis_ws_sn 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_cosm_gis_vlan_name}/cosm-gis-ws-sn'
  properties: {
    addressPrefix: '172.16.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan_name_resource
  ]
}

resource virtualNetworks_cosm_gis_vlan_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_cosm_gis_vlan_name}/GatewaySubnet'
  properties: {
    addressPrefix: '172.16.0.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_cosm_gis_vlan_name_resource
  ]
}