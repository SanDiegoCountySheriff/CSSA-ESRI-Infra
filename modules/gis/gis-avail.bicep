

param resourceAgency string = 'cosm'
param resourceType string = 'avail'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param availabilitySetPlatformFaultDomainCount int = 2
param availabilitySetPlatformUpdateDomainCount int = 5
param proximityPlacementGroupId string

resource availabilitySet 'Microsoft.Compute/availabilitySets@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: availabilitySetPlatformFaultDomainCount
    platformUpdateDomainCount: availabilitySetPlatformUpdateDomainCount
    proximityPlacementGroup: {
      id: proximityPlacementGroupId
    }
  }
}

output name string = availabilitySet.name
