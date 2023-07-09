param resourceAgency string = 'cosm'
param resourceScope string
param resourceEnv string
param resourceLocation string

param namePrefix string = '${resourceAgency}-${resourceScope}-${resourceEnv}'
param nameSuffix string = uniqueString(resourceGroup().id)

param enableAcceleratedNetworking bool = true
param appSecurityGroups array
param subnetName string
param virtualNetworkName string
param virtualMachineName string
param osDiskType string = 'Premium_LRS'
param osDiskDeleteOption string = 'Delete'
param virtualMachineSize string = 'Standard_D2s_v4'//'Standard_D4s_v3'
param nicDeleteOption string = 'Detach'

param adminUsername string
@secure()
param adminPassword string

param patchMode string = 'AutomaticByOS'
param enableHotpatching bool = false
param securityType string = 'TrustedLaunch'
param secureBoot bool = true
param vTPM bool = true

param availabilitySetName string
param proximityPlacementGroupName string

/*
param backupVaultName string
param backupFabricName string
param backupVaultRGName string
param backupVaultRGIsNew bool
param backupPolicyName string
param backupPolicySchedule object
param backupPolicyRetention object
param backupPolicyTimeZone string
param backupInstantRpRetentionRangeInDays int
param backupInstantRPDetails object
param backupItemName string
*/

var aadLoginExtensionName = 'AADLoginForWindows'

var dataDisks = [
  {
    id: null
    lun: 0
    createOption: 'Empty'
    deleteOption: 'Detach'
    caching: 'ReadOnly'
    writeAcceleratorEnabled: false
    name: '${virtualMachineName}_DataDisk_0'
    storageAccountType: null
    diskSizeGB: null
    diskEncryptionSet: null
  }
]

var dataDiskResources = [
  {
    name: '${virtualMachineName}_DataDisk_0'
    sku: 'Premium_LRS'
    properties: {
      diskSizeGB: 512
      creationData: {
        createOption: 'Empty'
      }
    }
  }
]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: virtualNetworkName
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2022-11-01' existing = {
  name: availabilitySetName
}

resource proximityPlacementGroup  'Microsoft.Compute/proximityPlacementGroups@2022-11-01' existing = {
  name: proximityPlacementGroupName
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: 'nic-${namePrefix}-${nameSuffix}'
  location: resourceLocation
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
          privateIPAllocationMethod: 'Dynamic'
          applicationSecurityGroups: appSecurityGroups
        }
      }
    ]
    enableAcceleratedNetworking: enableAcceleratedNetworking
    
  }
  dependsOn: [
    virtualNetwork
  ]
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
  dependsOn: [
    proximityPlacementGroup
    availabilitySet
    dataDiskResources_name
  ]
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-datacenter-gensecond'
        version: 'latest'
      }
      dataDisks: [for item in dataDisks: {
        lun: item.lun
        createOption: item.createOption
        caching: item.caching
        diskSizeGB: item.diskSizeGB
        managedDisk: {
          id: (item.id ?? ((item.name == null) ? null : resourceId(resourceGroup().name, 'Microsoft.Compute/disks', item.name)))
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
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: enableHotpatching
          patchMode: patchMode
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
      id: proximityPlacementGroup.id
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
}

/*

module BackupVaultAndOrPolicy_defaultVault724_EnhancedPolicy_ljnodtu7 './nested_BackupVaultAndOrPolicy_defaultVault724_EnhancedPolicy_ljnodtu7.bicep' = {
  name: 'BackupVaultAndOrPolicy-defaultVault724-EnhancedPolicy-ljnodtu7'
  scope: resourceGroup(backupVaultRGName)
  params: {
    resourceId_parameters_backupVaultRGName_Microsoft_RecoveryServices_vaults_parameters_backupVaultName: resourceId(backupVaultRGName, 'Microsoft.RecoveryServices/vaults', backupVaultName)
    backupVaultName: backupVaultName
    location: location
    backupPolicyName: backupPolicyName
    backupPolicySchedule: backupPolicySchedule
    backupPolicyRetention: backupPolicyRetention
    backupPolicyTimeZone: backupPolicyTimeZone
    backupInstantRpRetentionRangeInDays: backupInstantRpRetentionRangeInDays
    backupInstantRPDetails: backupInstantRPDetails
  }
}

module virtualMachineName_BackupIntent './nested_virtualMachineName_BackupIntent.bicep' = {
  name: '${virtualMachineName}-BackupIntent'
  scope: resourceGroup(backupVaultRGName)
  params: {
    resourceId_parameters_backupVaultRGName_Microsoft_RecoveryServices_vaults_backupPolicies_parameters_backupVaultName_parameters_backupPolicyName: resourceId(backupVaultRGName, 'Microsoft.RecoveryServices/vaults/backupPolicies', backupVaultName, backupPolicyName)
    resourceId_parameters_virtualMachineRG_Microsoft_Compute_virtualMachines_parameters_virtualMachineName: resourceId(virtualMachineRG, 'Microsoft.Compute/virtualMachines', virtualMachineName)
    backupVaultName: backupVaultName
    backupFabricName: backupFabricName
    backupItemName: backupItemName
    virtualMachineName: virtualMachineName
  }
  dependsOn: [
    resourceId(virtualMachineRG, 'Microsoft.Compute/virtualMachines', virtualMachineName)
    BackupVaultAndOrPolicy_defaultVault724_EnhancedPolicy_ljnodtu7
  ]
}
*/

resource virtualMachineName_aadLoginExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  parent: virtualMachine
  name:  aadLoginExtensionName
  location: resourceLocation
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: aadLoginExtensionName
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
    settings: {
      mdmId: ''
    }
  }
}

output adminUsername string = adminUsername
//output driveletter string = virtualMachine.properties.storageProfile.dataDisks.
