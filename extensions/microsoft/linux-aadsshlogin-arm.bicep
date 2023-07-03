param vmName string
param location string

resource vmName_AADSSHLogin 'Microsoft.Compute/virtualMachines/extensions@2015-06-15' = {
  name: '${vmName}/AADSSHLogin'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADSSHLoginForLinux'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

output name string = vmName_AADSSHLogin.name
