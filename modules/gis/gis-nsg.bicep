

@description('Location for all resources.') 
param location string = resourceGroup().location

param globalAgencyName string = 'cosm'
param globalApplicationName string = 'gis'
param globalPrefix string = '${globalAgencyName}-${globalApplicationName}'

param networkSecurityGroups_cosm_gis_ws_nsg_name string = '${globalPrefix}-ws-sn-nsg'

param applicationSecurityGroups_cosm_gis_ws_asg_name string = '${globalPrefix}-ws-sn-asg'
param applicationSecurityGroups_cosm_gis_app_asg_name string = '${globalPrefix}-app-sn-asg'
param applicationSecurityGroups_cosm_gis_web_asg_name string = '${globalPrefix}-web-sn-asg'
param applicationSecurityGroups_cosm_gis_data_asg_name string = '${globalPrefix}-data-sn-asg'

resource applicationSecurityGroups_cosm_gis_ws_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' existing = {
  name: applicationSecurityGroups_cosm_gis_ws_asg_name
}

resource networkSecurityGroups_cosm_gis_ws_nsg 'Microsoft.Network/networkSecurityGroups@2022-07-01' = {
  name: networkSecurityGroups_cosm_gis_ws_nsg_name
  location: location
  tags: {
    app: globalApplicationName
    tier: 'network'
    resource: 'nsg'
  }
  properties: {
    flushConnection: true
    securityRules: [
      {
        name: 'AllowRdpInboundToWsASG'
        properties: {
          access: 'Allow'
          description: 'Allow RDP from CoSM LAN'
          destinationApplicationSecurityGroups: [
            applicationSecurityGroups_cosm_gis_ws_asg
          ]
          destinationPortRange: '3389'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'VirtualNetwork'
          ]
          sourcePortRange: '*'
        }
        type: 'string'
      }
      {
        name: 'AllowSSHInboundToWsASG'
        properties: {
          access: 'Allow'
          description: 'Allow RDP from CoSM LAN'
          destinationApplicationSecurityGroups: [
            applicationSecurityGroups_cosm_gis_ws_asg
          ]
          destinationPortRange: '22'
          direction: 'Inbound'
          priority: 100
          protocol: 'Tcp'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'VirtualNetwork'
          ]
          sourcePortRange: '*'
        }
        type: 'string'
      }
      {
        name: 'AllowBackupInboundToWsASG'
        properties: {
          access: 'Allow'
          description: 'Allow Backup from CoSM LAN'
          destinationApplicationSecurityGroups: [
            applicationSecurityGroups_cosm_gis_ws_asg
          ]
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 101
          protocol: 'Tcp'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'AzureBackup'
          ]
          sourcePortRange: '*'
        }
        type: 'string'
      }
      {
        name: 'DenyAllInboundToWsASG'
        properties: {
          access: 'Deny'
          description: 'Deny All Inbound'
          destinationApplicationSecurityGroups: [
            applicationSecurityGroups_cosm_gis_ws_asg
          ]
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 1000
          protocol: 'Tcp'
          sourceAddressPrefix: 'string'
          sourceAddressPrefixes: [
            'VirtualNetwork'
          ]
          sourcePortRange: '*'
        }
        type: 'string'
      }
    ]
  }
}
