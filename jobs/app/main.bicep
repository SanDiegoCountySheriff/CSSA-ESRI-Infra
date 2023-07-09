@description('Location for all resources.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'prd'
  'stg'
  'ist'
  'uat'
  'dev'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param virtualMachineName string

resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-03-01' existing = {
  name: virtualMachineName
}

var serverConfig = {
  AllNodes: [
      {
        NodeName: virtualMachine.properties.osProfile.computerName
        Role: ['Server']
      }
  ]
  ConfigData: {
    Version: '10.9.1'
    ServerRole: 'GeneralPurposeServer'
    Credentials: {
        ServiceAccount: {
          Password: '[ServiceAccount Password]'
          UserName: '[ServiceAccount Username - Can be a Domain Account]'
          IsDomainAccount: true
          IsMSAAccount: false
        }
      }
      Server: {
        LicenseFilePath: '[License File Path - Server ]'
        Installer: {
          Path: '[Server Installer Path]'
          InstallDir: 'D:\\ArcGIS\\Server'
          InstallDirPython: 'D:\\Python27'
          EnableArcMapRuntime: true
          EnableDotnetSupport: true
          }
          ServerDirectoriesRootLocation: 'D:\\arcgisserver\\directories'
          ConfigStoreLocation: 'D:\\arcgisserver\\config-store'
          PrimarySiteAdmin: {
            UserName: 'siteadmin'
            Password: 'bq_WbGX7Nu9'
          }
          ExternalLoadBalancer: 'webmaps-NonProd.san-marcos.net'
          InternalLoadBalancer: 'webmaps-NonProd.san-marcos.net'
      }
  }
}

/*
resource virtualMachineArcGISPowerShellExtension 'Microsoft.Compute/virtualMachines/extensions@2019-12-01' = {
  parent: virtualMachine
  name: 'DSCConfiguration'
  location: location
  properties: {
    publisher: 'Microsoft.Powershell'
    type: 'DSC'
    typeHandlerVersion: '2.77'
    autoUpgradeMinorVersion: true
    settings: {
      wmfVersion: 'latest'
      configuration: {
        url: 'https://github.com/Esri/arcgis-powershell-dsc/archive/refs/heads/main.zip'
        function: 'BaseDeploymentSingleTierConfiguration'
        script: 'BaseDeploymentSingleTierConfiguration.ps1'
      }
      advancedOptions: {
        forcePullAndApply: false
      }
      configurationArguments: {
        ServiceCredentialIsDomainAccount: arcgisServiceAccountIsDomainAccount
        PublicKeySSLCertificateFileUrl: (empty(publicKeySSLCertificateFileName) ? '' : '${_artifactsLocation}/${publicKeySSLCertificateFileName}${_artifactsLocationSasToken}')
        ServerLicenseFileUrl: (empty(serverLicenseFileName) ? '' : '${_artifactsLocation}/${serverLicenseFileName}${_artifactsLocationSasToken}')
        PortalLicenseFileUrl: (empty(portalLicenseFileName) ? '' : '${_artifactsLocation}/${portalLicenseFileName}${_artifactsLocationSasToken}')
        PortalLicenseUserTypeId: (empty(portalLicenseUserTypeId) ? '' : portalLicenseUserTypeId)
        MachineName: first(virtualMachineNames)
        PeerMachineName: last(virtualMachineNames)
        ExternalDNSHostName: externalDnsHostName
        PrivateDNSHostName: secondaryDnsHostName
        DataStoreTypes: dataStoreTypesForBaseDeploymentServers
        IsTileCacheDataStoreClustered: isTileCacheDataStoreClustered
        FileShareName: fileShareName
        UseCloudStorage: useCloudStorage
        UseAzureFiles: useAzureFiles
        OSDiskSize: virtualMachineOSDiskSize
        EnableDataDisk: string(enableVirtualMachineDataDisk)
        EnableLogHarvesterPlugin: string(enableServerLogHarvesterPlugin)
        DebugMode: string(debugMode)
        ServerContext: serverContext
        PortalContext: portalContext
        IsUpdatingCertificates: isUpdatingCertificates
      }
    }
    protectedSettings: {
      configurationUrlSasToken: _artifactsLocationSasToken
      configurationArguments: {
        ServiceCredential: {
          userName: (empty(arcgisServiceAccountUserName) ? 'PlaceHolder' : arcgisServiceAccountUserName)
          password: (empty(arcgisServiceAccountPassword) ? 'PlaceHolder' : arcgisServiceAccountPassword)
        }
        MachineAdministratorCredential: {
          userName: (empty(adminUsername) ? 'PlaceHolder' : adminUsername)
          password: (empty(adminPassword) ? 'PlaceHolder' : adminPassword)
        }
        ServerInternalCertificatePassword: {
          userName: 'Placeholder'
          password: ((string(useSelfSignedInternalSSLCertificate) == 'True') ? selfSignedSSLCertificatePassword : serverInternalCertificatePassword)
        }
        PortalInternalCertificatePassword: {
          userName: 'Placeholder'
          password: ((string(useSelfSignedInternalSSLCertificate) == 'True') ? selfSignedSSLCertificatePassword : portalInternalCertificatePassword)
        }
        SiteAdministratorCredential: {
          userName: primarySiteAdministratorAccountUserName
          password: primarySiteAdministratorAccountPassword
        }
        StorageAccountCredential: {
          userName: cloudStorageAccountCredentialsUserName[string(useCloudStorage)]
          password: cloudStorageAccountCredentialsPassword[string(useCloudStorage)]
        }
      }
    }
  }
}
*/
