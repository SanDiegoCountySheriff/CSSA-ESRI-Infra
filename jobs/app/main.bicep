


@description('Location for all resources.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

param virtualMachineName string


resource virtualMachine 'Microsoft.Compute/virtualMachines@2022-03-01' existing = {
  name: virtualMachineName
}

resource virtualMachineArcGISExtension 'Microsoft.Compute/virtualMachines/extensions@2018-06-01' = {
  name: 'virtualMachineName/config-app'
  location: resourceGroup().location
  tags: {
    displayName: 'config-app'
  }
  properties: {
    publisher: 'Quartic Solutions'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
        AllNodes: [
            {
                NodeName: 'csm-gis-NonProd-datastore'
                DataStoreTypes: [
                    'Relational'
                    'SpatioTemporal'
                ]
                Role: [
                    'DataStore'
                ]
                SslCertificates: [
                    {
                        Path: 'DataStore SSL Certificate Path]'
                        Password: '[DataStore SSL Password]'
                        CNameFQDN: '[DataStore CName Alias]'
                        Target: [
                            'DataStore'
                        ]
                    }
                ]
            }
            {
              NodeName: 'cosm-gis-NonProd-portal'
                Role: [
                  'Portal'
                  'PortalWebAdaptor'
                  'ServerWebAdaptor'
                  'LicenseManager'
                ]
                SslCertificates: [
                    {
                        Path: '[Portal SSL Certificate Path]'
                        Password: '[Portal SSL Password]'
                        CNameFQDN: '[Portal CName Alias]'
                        Target: [
                            'Portal'
                        ]
                    }
                ]
            }
            {
              NodeName: 'csm-gis-NonProd-hosting'
              Role: [
                    'Server'
                ]
                SslCertificates: [
                    {
                      Path: '[Server SSL Certificate Path]'
                      Password: '[Server SSL Password]'
                      CNameFQDN: '[Server CName Alias]'
                      Target: [
                            'Server'
                        ]
                    }
                ]
            }
        ]
        ConfigData: {
          Version: '10.9.1'
          ServerContext: 'server'
          PortalContext: 'portal'
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
                Path: "[Server Installer Path]'
                InstallDir: 'D:\\ArcGIS\\Server'
                InstallDirPython: 'D:\\Python27'
                EnableArcMapRuntime: true
                EnableDotnetSupport: true
                }
                ServerDirectoriesRootLocation: "D:\\arcgisserver\\directories'
                ConfigStoreLocation: "D:\\arcgisserver\\config-store'
                PrimarySiteAdmin: {
                  UserName: 'siteadmin'
                  Password: 'bq_WbGX7Nu9'
                }
                ExternalLoadBalancer: 'webmaps-NonProd.san-marcos.net'
                InternalLoadBalancer: 'webmaps-NonProd.san-marcos.net'
            }
            Portal: {
              LicenseFilePath: '[License File Path - Portal ]'
              PortalLicenseUserTypeId: 'creatorUT'
              Installer: {
                Path: '[Portal Installer Path]'
                WebStylesPath: '[Optional Parameter starting ArcGIS Enterprise 10.7.1 - Portal Web Styles Installer Path]'
                InstallDir: 'D:\\ArcGIS\\Portal'
                ContentDir: 'D:\\arcgisportal'
                }
                ContentDirectoryLocation:'D:\\arcgisportal\\content'
                PortalAdministrator: {
                  UserName: 'portaladmin'
                  Email: '[PortalAdministrator Email]'
                  Password: 'tUsAzz_Y9c0D'
                  SecurityQuestionIndex: 1
                  SecurityAnswer: 'San Marcos'
                }
                DefaultRoleForUser:'iAAAAAAAAAAAAAAA'
                DefaultUserLicenseTypeIdForUser: 'viewerUT'
                ExternalLoadBalancer: 'webmaps-NonProd.san-marcos.net'
                InternalLoadBalancer: 'webmaps-NonProd.san-marcos.net'
            }
            DataStore: {
              ContentDirectoryLocation: 'D:\\arcgisdatastore'
              EnableFailoverOnPrimaryStop: false
              EnablePointInTimeRecovery:true
              Installer: {
                Path: '[DataStore Installer Path]'
                InstallDir: 'D:\\ArcGIS\\DataStore'
              }
            }
            WebAdaptor: {
              AdminAccessEnabled: true
              Installer: {
                  Path: '[WebAdaptor Installer Path]''
                }
            }
            LicenseManagerVersion: '2022.1'
            LicenseManager: {
              LicenseFilePath: '[License File Path (*.prvs) - License Manager ]'
              Installer: {
                Path: '[License Manager Installer Path]'
                IsSelfExtracting: true
                InstallDir: 'D:\\ArcGIS\\LM'
              }
            }
        }
    }
    protectedSettings: {
      commandToExecute: 'myExecutionCommand'
      storageAccountName: 'myStorageAccountName'
      storageAccountKey: 'myStorageAccountKey'
      managedIdentity: {}
      fileUris: [
        '../../extensions/quartic/1_Install_Esri_PS_Module.ps1'
        '../../extensions/quartic/2_Install_Esri_PS_Module.ps1'
        '../../extensions/quartic/3_Install_Esri_PS_Module.ps1'
      ]
    }
  }
  dependsOn: [
    virtualMachine
  ]
}
