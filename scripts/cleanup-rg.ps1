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

    Start-ThreadJob {
        Connect-AzAccount -ServicePrincipal -Tenant 'cc3e0e2d-a2a6-4495-97d5-8999e9bb2aa3' -Credential System.Management.Automation.PSCredential -Environment AzureCloud @processScope
        Set-AzContext -SubscriptionId '66d233df-ad0c-45a4-a6bc-d77919e18237' -TenantId 'cc3e0e2d-a2a6-4495-97d5-8999e9bb2aa3'
        Remove-AzResourceGroup -Name $rg_resource_name -AsJob -Force
    
    } | Receive-Job -Wait -AutoRemoveJob
}

