Set-ExecutionPolicy RemoteSigned

#Configure the Credential variable
$User = "Domain01\User01"   #Use domain\account (NOT acc@domain)
$PWord = ConvertTo-SecureString -String "P@sSwOrd" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

#Run Install
Invoke-ArcGISConfiguration -ConfigurationParametersFile C:\Temp\BaseDeployment.json -Mode InstallLicenseConfigure -Credential $Credential