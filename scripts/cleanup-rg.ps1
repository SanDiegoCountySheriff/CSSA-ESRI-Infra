# Clean up PowerShell resources.

$prefix = 'rg-cosm-gis-env-test'
$subscriptionId = '66d233df-ad0c-45a4-a6bc-d77919e18237'

# Set the subscription.
Set-AzContext -SubscriptionId $subscriptionId

# List all resource groups that will be removed.
Get-AzResourceGroup | ? ResourceGroupName -match $prefix | Select-Object ResourceGroupName

# Remove the resource groups shown in the preceding command.
Get-AzResourceGroup | ? ResourceGroupName -match $prefix | Remove-AzResourceGroup -AsJob -Force