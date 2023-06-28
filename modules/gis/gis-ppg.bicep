
param resourceAgency string = 'cosm'
param resourceType string = 'vnet'
param resourceScope string
param resourceEnv string
param resourceLocation string
param resourceNumber string = '001'

param namePrefix string = '${resourceType}-${resourceAgency}'
param nameSuffix string = '${resourceEnv}-${resourceNumber}'

resource symbolicname 'Microsoft.Compute/proximityPlacementGroups@2022-11-01' = {
  name: '${namePrefix}-${resourceScope}-${nameSuffix}'
  location: resourceLocation
  tags: {
    agency: resourceAgency
    app: resourceScope
    env: resourceEnv
  }
}
