param resourceAgency string = 'cosm'
param resourceType string = 'asg'
param resourceScope string
param resourceEnv string
param resourceLocation string
param resourceNumber string = '001'

param namePrefix string = '${resourceType}-${resourceAgency}'
param nameSuffix string = '${resourceEnv}-${resourceNumber}'

resource applicationSecurityGroup_ws 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: '${namePrefix}-${resourceScope}-${nameSuffix}-001'
  location: resourceLocation
  tags: {
    app: resourceScope
    tier: 'workstation'
    env: resourceEnv
    type: resourceType
  }
  properties: {}
}

resource applicationSecurityGroups_cosm_gis_app_asg 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: '${namePrefix}-${resourceScope}-${nameSuffix}-002'
  location: resourceLocation
  tags: {
    app: resourceScope
    tier: 'application'
    env: ''
    resource: 'asg'
  }
  properties: {}
}
