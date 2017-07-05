<#
PowerShell Runbook to pause Azure SQL Data Warehouse instances
 adapted from https://blogs.sentryone.com/briandavis/using-azure-automation-pause-sqldw/
#>
param(
    # the desired subscription ID
    [Parameter(Mandatory=$true)][string]$subscriptionId,
    # optional resource group name
    #   If not provided, then all SQL Data Warehouse instances within
    #   the subscription will be paused.
    [Parameter(Mandatory=$false)][string]$resourceGroupName
)

# Get the connection
$servicePrincipalConnection = Get-AutomationConnection -Name AzureRunAsConnection         

"Logging in to Azure..."
Add-AzureRmAccount `
    -ServicePrincipal `
    -TenantId $servicePrincipalConnection.TenantId `
    -ApplicationId $servicePrincipalConnection.ApplicationId `
    -CertificateThumbprint   $servicePrincipalConnection.CertificateThumbprint

"setting subscription context..."
set-azurermcontext `
    -SubscriptionId $subscriptionId `
    -TenantId $servicePrincipalConnection.TenantId

if ($resourceGroupName) {
    "Getting all SQL DWs in the resource group..."
    $dataWarehouses = Get-AzureRmResource | `
        Where-Object ResourceType -EQ "Microsoft.Sql/servers/databases" | `
        Where-Object Kind -ILike "*datawarehouse*" | `
        where-object resourcegroupname -EQ $resourceGroupName
} else {
    "Getting all SQL DWs in the subscription..."
    $dataWarehouses = Get-AzureRmResource | `
        Where-Object ResourceType -EQ "Microsoft.Sql/servers/databases" | `
        Where-Object Kind -ILike "*datawarehouse*"
}
 
"looping through data warehouses..."
""
foreach($dataWarehouse in $dataWarehouses)
{
    "working on data warehouse: " + $dataWarehouse.ResourceName
    $dwc = $dataWarehouse.ResourceName.split("/")
    

    $ThisDW = @{
        'ResourceGroupName' = $dataWarehouse.ResourceGroupName
        'ServerName' = $dwc[0]
        'DatabaseName' = $dwc[1]
    }
 
    $status = Get-AzureRmSqlDatabase @ThisDW | Select Status
    "warehouse status: " + $status.Status

    # Check the status
    if($status.Status -ne "Paused") {
        # If the status is not equal to "Paused", pause the SQLDW
        Suspend-AzureRmSqlDatabase @ThisDW -ErrorAction Continue -ErrorVariable suspendError
        if ($suspendError) {
            "failed to pause/suspend Data Warehouse: " + $suspendError
        } else {
            "data warehouse paused/suspended successfully"
        }        
    } else  {
        "no work to do - warehouse already paused"
    }
    write-output ""
}
