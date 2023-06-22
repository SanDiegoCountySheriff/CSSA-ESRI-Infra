# Clean up PowerShell resources.

 param (
    [Parameter(Mandatory=$true)]
    [string]$rg = ""
 )

Get-AzResourceGroup -Name $rg -ErrorVariable notPresent -ErrorAction SilentlyContinue
if ($notPresent) {
    exit(0)
}
else {
    $rg_resource = Get-AzResourceGroup -Name $rg 
    $rg_resource_name = ($rg_resource).ResourceGroupName 
    $rg_resource_location = ($rg_resource).Location

    Remove-AzResourceGroup -Name $rg_resource_name -AsJob -Force
    # | Receive-Job -Wait -AutoRemoveJob
}

