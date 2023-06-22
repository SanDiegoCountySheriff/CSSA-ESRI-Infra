# Clean up PowerShell resources.

 param (
    [Parameter(Mandatory=$true)]
    [string]$rg = ""
    [Parameter(Mandatory=$true)]
    [string]$subscriptionId = ""
 )
# Set the subscription.
Set-AzContext -SubscriptionId $subscriptionId

# List all resource groups that will be removed.
Get-AzResourceGroup | ? ResourceGroupName -match $rg | Select-Object ResourceGroupName

# Remove the resource groups shown in the preceding command.
Get-AzResourceGroup | ? ResourceGroupName -match $rg | Remove-AzResourceGroup -AsJob -Force