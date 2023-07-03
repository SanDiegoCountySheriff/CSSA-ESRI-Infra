param resourceAgency string = 'cosm'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param enableAcceleratedNetworking bool = true
param networkSecurityGroupName string
param networkSecurityGroupRules array
param subnetName string
param virtualNetworkName string
param virtualMachineName string
param virtualMachineComputerName string
param osDiskType string
param osDiskDeleteOption string
param dataDisks array
param dataDiskResources array
param virtualMachineSize string
param nicDeleteOption string
param adminUsername string

@secure()
param adminPassword string
param securityType string
param secureBoot bool = true
param vTPM bool
param proximityPlacementGroupId string
param availabilitySetName string

var nsgId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var vnetName = virtualNetworkName
var vnetId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetRef = '${vnetId}/subnets/${subnetName}'
var aadLoginExtensionName = 'AADSSHLoginForLinux'


resource networkInterface 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: 'nic-${namePrefix}-${nameSuffix}'
  location: resourceLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
    networkSecurityGroup: {
      id: nsgId
    }
  }
  dependsOn: [
    networkSecurityGroup
    virtualNetwork
  ]
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
  name: 'nsg-${namePrefix}-${nameSuffix}'
  location: resourceLocation
  properties: {
    securityRules: networkSecurityGroupRules
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-01-01' existing = {
  name: vnetName
}

resource dataDiskResources_name 'Microsoft.Compute/disks@2022-03-02' = [for item in dataDiskResources: {
  name: item.name
  location: resourceLocation
  sku: {
    name: item.sku
  }
  properties: item.properties
}]

resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: virtualMachineName
  location: resourceLocation
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'fromImage'
        managedDisk: {
          storageAccountType: osDiskType
        }
        deleteOption: osDiskDeleteOption
      }
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      dataDisks: [for item in dataDisks: {
        lun: item.lun
        createOption: item.createOption
        caching: item.caching
        diskSizeGB: item.diskSizeGB
        managedDisk: {
          id: (item.id ?? ((item.name == json('null')) ? json('null') : resourceId('Microsoft.Compute/disks', item.name)))
          storageAccountType: item.storageAccountType
        }
        deleteOption: item.deleteOption
        writeAcceleratorEnabled: item.writeAcceleratorEnabled
      }]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
          properties: {
            deleteOption: nicDeleteOption
          }
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        patchSettings: {
          patchMode: 'ImageDefault'
        }
      }
    }
    securityProfile: {
      securityType: securityType
      uefiSettings: {
        secureBootEnabled: secureBoot
        vTpmEnabled: vTPM
      }
    }
    proximityPlacementGroup: {
      id: proximityPlacementGroupId
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    availabilitySet: {
      id: availabilitySet.id
    }
  }
  dependsOn: [
    dataDiskResources_name

  ]
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2019-07-01' existing = {
  name: availabilitySetName
}

module microsoft_linux_aadsshlogin '../../extensions/microsoft/linux-aadsshlogin-arm.bicep' = {
  name: 'microsoft.linux-aadsshlogin'
  params: {
    vmName: 'cosm-gis-test-notebook'
    location: 'westus3'
  }
  dependsOn: [
    virtualMachine
  ]
}

resource virtualMachineName_aadLoginExtension 'Microsoft.Compute/virtualMachines/extensions@2018-10-01' = {
  parent: virtualMachine
  name: 'microsoft.linux-aadsshlogin'
  location: resourceLocation
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: aadLoginExtensionName
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
  dependsOn: [
    microsoft_linux_aadsshlogin
  ]
}

output adminUsername string = adminUsername
