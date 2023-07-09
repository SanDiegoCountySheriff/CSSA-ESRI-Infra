param resourceAgency string = 'cosm'
param resourceType string = 'asg'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

resource applicationSecurityGroup_ws 'Microsoft.Network/applicationSecurityGroups@2022-07-01' = {
  name: '${namePrefix}-${nameSuffix}'
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
