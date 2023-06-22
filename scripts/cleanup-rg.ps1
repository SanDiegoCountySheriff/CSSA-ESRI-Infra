# Clean up PowerShell resources.

 param (
    [Parameter(Mandatory=$true)]
    [string]$rg = ""
    #[Parameter(Mandatory=$true)]
    #[string]$subscriptionId = ""
 )

# List all resource groups that will be removed.
#Get-AzResourceGroup | ? ResourceGroupName -match $rg | Select-Object ResourceGroupName
$rg_resource = Get-AzResourceGroup -Name $rg

$rg_resource_name = ($rg_resource).ResourceGroupName 
$rg_resource_location = ($rg_resource).Location

Remove-AzResourceGroup -Name $rg_resource_name -AsJob -Force

New-AzResourceGroup -Name ResourceGroupName -Location $rg_resource_location

# Remove the resource groups shown in the preceding command.
