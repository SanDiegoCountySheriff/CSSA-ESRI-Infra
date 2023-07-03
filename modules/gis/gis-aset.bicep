
param availabilitySetName string
param location string
param availabilitySetPlatformFaultDomainCount int 
param availabilitySetPlatformUpdateDomainCount int
param proximityPlacementGroupId string

resource availabilitySet 'Microsoft.Compute/availabilitySets@2019-07-01' = {
  name: availabilitySetName
  location: location
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
