
param resourceAgency string = 'cosm'
param resourceType string = 'nsg'
param resourceScope string
param resourceEnv string
param nsgScopeName string

param namePrefix string = '${resourceType}-${resourceScope}-${resourceEnv}-${nsgScopeName}'
param nameSuffix string = uniqueString(resourceGroup().id)

param resourceLocation string = resourceGroup().location

param securityRules array = []

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: '${namePrefix}-${nameSuffix}'
  location: resourceLocation
  properties: {
    securityRules: securityRules
  }
}

output id string = nsg.id
