

var computerName = $env:computername

New-Item -ItemType Directory -Path "D:\\inetpub\\wwwroot"
Add-WindowsFeature Web-Server; powershell Add-Content -Path \"D:\\inetpub\\wwwroot\\Default.htm\" -Value $(computerName)