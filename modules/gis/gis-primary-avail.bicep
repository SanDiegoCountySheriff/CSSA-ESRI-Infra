

param resourceAgency string = 'cosm'
param resourceType string = 'avail'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceType}-${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param availabilitySetPlatformFaultDomainCount int 
param availabilitySetPlatformUpdateDomainCount int
param proximityPlacementGroupId string

resource availabilitySet 'Microsoft.Compute/availabilitySets@2019-07-01' = {
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
