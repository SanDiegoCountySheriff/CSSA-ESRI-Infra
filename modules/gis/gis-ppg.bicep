
param resourceAgency string = 'cosm'
param resourceType string = 'vnet'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
  tags: {
    agency: resourceAgency
    app: resourceScope
    env: resourceEnv
  }
}

output id string = proximityPlacementGroup.id
output name string = proximityPlacementGroup.name
