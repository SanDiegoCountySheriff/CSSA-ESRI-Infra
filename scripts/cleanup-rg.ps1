# Clean up PowerShell resources.

 param (
    [Parameter(Mandatory=$true)]
    [string]$rg = ""
    #[Parameter(Mandatory=$true)]
    #[string]$subscriptionId = ""
 )

$id = convertfrom-json (az account list --query "[?isDefault].id | [0]")

# Set the subscription.
Set-AzContext -SubscriptionId $id

# List all resource groups that will be removed.
Get-AzResourceGroup | ? ResourceGroupName -match $rg | Select-Object ResourceGroupName

# Remove the resource groups shown in the preceding command.
Get-AzResourceGroup | ? ResourceGroupName -match $rg | Remove-AzResourceGroup -AsJob -Force