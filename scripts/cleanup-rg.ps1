# Clean up PowerShell resources.

 param (
    [Parameter(Mandatory=$true)]
    [string]$rg = ""
    #[Parameter(Mandatory=$true)]
    #[string]$subscriptionId = ""
 )

# List all resource groups that will be removed.
#Get-AzResourceGroup | ? ResourceGroupName -match $rg | Select-Object ResourceGroupName
Get-AzResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
if ($notPresent) {
    exit(0)
}
else {
    $rg_resource_name = ($rg_resource).ResourceGroupName 
    $rg_resource_location = ($rg_resource).Location

    Remove-AzResourceGroup -Name $rg_resource_name -AsJob -Force | Receive-Job -Wait -AutoRemoveJob
}

